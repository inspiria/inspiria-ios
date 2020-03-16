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
    let book: BookInfo
    let index: Int

    lazy var state = BehaviorRelay<HoodState>(value: isDownloaded ? .downloaded : .none)
    let onDownload = PublishSubject<Void>()

    var isDownloaded: Bool {
        return useCase.isBookDownloaded(id: self.book.id)
    }

    init (useCase: BooksUseCase,
          book: BookInfo,
          index: Int) {
        self.useCase = useCase
        self.book = book
        self.index = index
    }

    func transform() -> Output {
        let book = Driver.just(self.book)
        let download = onDownload.asDriverOnErrorJustComplete()
            .flatMap { [unowned self] _ -> Driver<Double> in
                return self.useCase
                    .downloadBook(id: self.book.id)
                    .asDriver(onErrorJustReturn: -1.0)
                    .startWith(0.0)
        }
        .do(onNext: { [unowned self] prg in
            switch prg {
            case -1.0: self.state.accept(.error)
            case 1.0: self.state.accept(.downloaded)
            default: self.state.accept(.downloading)
            }
        })

        return Output(book:book,
                      state: state.asDriver(),
                      downloadProgress: download)
    }
}

extension BooksListItemViewModel {
    struct Output {
        let book: Driver<BookInfo>
        let state: Driver<HoodState>
        let downloadProgress: Driver<Double>
    }

    enum HoodState {
        case none, deselected, selected, downloaded, downloading, error
        var isSelected: Bool {
            if case self = HoodState.selected {
                return true
            } else {
                return false
            }
        }
    }
}
