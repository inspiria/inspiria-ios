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
        let book = Driver.just(self.book)
        let state = Driver<State>.just(self.useCase.isBookDownloaded(id: self.book.id) ? .downloaded : .waiting)
        let selectionEnabled = Driver.just(false)
        let selected = Driver.just(false)

        return Output(book:book,
                      state: state,
                      selectionEnabled: selectionEnabled,
                      selected: selected)
    }

}

extension BooksListItemViewModel {
    struct Input {
        let onSelect: Driver<Void>
    }
    struct Output {
        let book: Driver<BookInfo>
        let state: Driver<State>
        let selectionEnabled: Driver<Bool>
        let selected: Driver<Bool>
    }

    enum State {
        case waiting
        case downloaded
        case downloading
        case error
    }
}
