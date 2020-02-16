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
    let booksUseCase: BooksUseCase

    init (booksUseCase: BooksUseCase) {
        self.booksUseCase = booksUseCase
    }

    func transform(input: Input) -> Output {

        let books = self.booksUseCase.books().asDriver(onErrorJustReturn: [])

        return Output(books: books)
    }
}

extension BooksListViewModel {
    struct Input {
    }
    struct Output {
        let books: Driver<[Book]>
    }
}
