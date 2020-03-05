//
//  BookViewModel.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BookViewModel {
    private let booksUseCase: BooksUseCase
    private let navigator: BookNavigator
    private let bookInfo: BookInfo

    init (booksUseCase: BooksUseCase,
          navigator: BookNavigator,
          bookInfo: BookInfo) {
        self.booksUseCase = booksUseCase
        self.navigator = navigator
        self.bookInfo = bookInfo
    }

    func transform(input: Input) -> Output {
        let info = Driver.just(bookInfo)
        let chapters = booksUseCase
            .book(id: bookInfo.id)
            .map { $0.chapters }
            .asObservable()
            .asDriverOnErrorJustComplete()

        let open = input.onSelect
            .withLatestFrom(chapters) { $1[$0] }
            .do(onNext: navigator.to)
            .mapToVoid()

        return Output(info: info, chapters: chapters, open: open)
    }
}

extension BookViewModel {
    struct Input {
        let onSelect: Driver<Int>
    }
    struct Output {
        let info: Driver<BookInfo>
        let chapters: Driver<[Chapter]>
        let open: Driver<Void>
    }
}
