//
//  BooksListViewModel.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BooksListViewModel {
    private let booksUseCase: BooksUseCase
    private let navigator: BooksListNavigator

    init (booksUseCase: BooksUseCase, navigator: BooksListNavigator) {
        self.booksUseCase = booksUseCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let books = booksUseCase.books()
            .asDriver(onErrorJustReturn: [])

        let select = input.onSelect
            .withLatestFrom(books) { $1[$0] }
            .do(onNext: navigator.to)
            .mapToVoid()

        let fetch = booksUseCase
            .fetchBooks()
            .asDriver(onErrorJustReturn: ())

        return Output(books: books, select: select, fetch: fetch)
    }
}

extension BooksListViewModel {
    struct Input {
        let onSelect: Driver<Int>
    }
    struct Output {
        let books: Driver<[BookInfo]>
        let select: Driver<Void>
        let fetch: Driver<Void>
    }
}
