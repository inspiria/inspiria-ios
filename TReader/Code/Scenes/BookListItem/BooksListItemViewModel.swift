//
//  BooksListItemViewModel.swift
//  TReader
//
//  Created by tadas on 2020-02-29.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BooksListItemViewModel {
    private let useCase: BooksUseCase
    private let navigator: BooksListNavigator
    private let book: BookInfo

    init (useCase: BooksUseCase,
          navigator: BooksListNavigator,
          book: BookInfo) {
        self.useCase = useCase
        self.navigator = navigator
        self.book = book
    }

    func transform(input: Input) -> Output {
        let initState = useCase.isBookDownloaded(id: self.book.id) ? Download.downloaded : Download.waiting
        let book = Driver.just(self.book)
        let state = getState(onSelect: input.onSelect).startWith(initState)
        let selectionEnabled = Driver.just(false)
        let selected = Driver.just(false)

        return Output(book:book,
                      state: state,
                      selectionEnabled: selectionEnabled,
                      selected: selected)
    }

    func getState(onSelect: Driver<Void>) -> Driver<Download> {
        return onSelect.flatMap { [unowned self] state -> Driver<Download> in
            if self.useCase.isBookDownloaded(id: self.book.id) {
                return Driver.just(Download.downloaded)
            }
            return self.useCase
                .downloadBook(id: self.book.id)
                .map { Download( $0 < 1.0 ? .downloading : .downloaded, $0) }
                .asDriver(onErrorJustReturn: Download.error)
        }
    }
}

extension BooksListItemViewModel {
    struct Input {
        let onSelect: Driver<Void>
    }
    struct Output {
        let book: Driver<BookInfo>
        let state: Driver<Download>
        let selectionEnabled: Driver<Bool>
        let selected: Driver<Bool>
    }

    struct Download {
        enum State {
            case waiting, downloaded, downloading, error
        }

        let state: State
        let progress: Double

        static var waiting = Download(.waiting, 0.0)
        static var downloaded = Download(.downloaded, 1.0)
        static var error = Download(.error, 0.0)

        init(_ state: State, _ progress: Double) {
            self.state = state
            self.progress = progress
        }
    }
}
