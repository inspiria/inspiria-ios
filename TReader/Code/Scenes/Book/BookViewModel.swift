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
    private let bookId: Int

    init (booksUseCase: BooksUseCase,
          navigator: BookNavigator,
          bookId: Int) {
        self.booksUseCase = booksUseCase
        self.navigator = navigator
        self.bookId = bookId
    }

    func transform(input: Input) -> Output {
        let chapters = Driver.just(bookId)
            .flatMap { self.booksUseCase.book(id: $0)
                .asDriver(onErrorJustReturn: [])
        }
        return Output(chapters: chapters)
    }
}

extension BookViewModel {
    struct Input {
    }
    struct Output {
        let chapters: Driver<[Chapter]>
    }
}
