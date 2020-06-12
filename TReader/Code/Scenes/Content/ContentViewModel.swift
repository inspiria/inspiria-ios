//
//  ContentViewModel.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ContentViewModel {
    private let booksUseCase: BooksUseCase
    private let navigator: ContentNavigator
    private let book: Book

    init (booksUseCase: BooksUseCase,
          navigator: ContentNavigator,
          book: Book) {
        self.booksUseCase = booksUseCase
        self.navigator = navigator
        self.book = book
    }

    func transform(input: Input) -> Output {
        let open = input.onSelect
            .map { (self.book.chapters[$0].id, self.book) }
            .do(onNext: navigator.to)
            .mapToVoid()

        return Output(book: book,
                      open: open)
    }
}

extension ContentViewModel {
    struct Input {
        let onSelect: Driver<Int>
    }
    struct Output {
        let book: Book
        let open: Driver<Void>
    }
}
