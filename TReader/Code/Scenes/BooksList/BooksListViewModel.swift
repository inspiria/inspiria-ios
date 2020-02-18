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
    private let booksListUseCase: BooksListUseCase
    private let bookUseCase: BookUseCase
    private let navigator: BooksListNavigator

    init (booksListUseCase: BooksListUseCase,
          bookUseCase: BookUseCase,
          navigator: BooksListNavigator) {
        self.booksListUseCase = booksListUseCase
        self.bookUseCase = bookUseCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let books = self.booksListUseCase
            .books()
            .map { [unowned self] in $0.map { BookState(downloaded: self.bookUseCase.bookExists(id: $0.id), book: $0) } }
            .asDriver(onErrorJustReturn: [])

        let select = input.onSelect
            .withLatestFrom(books) { $1[$0].book }
            .do(onNext: navigator.to)
            .mapToVoid()

        return Output(books: books, select: select)
    }
}

struct BookState {
    let downloaded: Bool
    let book: BookShort
}

extension BooksListViewModel {
    struct Input {
        let onSelect: Driver<Int>
    }
    struct Output {
        let books: Driver<[BookState]>
        let select: Driver<Void>
    }
}
