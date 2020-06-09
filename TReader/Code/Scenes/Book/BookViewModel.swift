//
//  BookViewModel.swift
//  TReader
//
//  Created by tadas on 2020-06-09.
//  Copyright © 2020 Scale3C. All rights reserved.
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

    func transform() -> Output {
        let errorTracker = ErrorTracker()
        let book = booksUseCase
            .book(id: bookInfo.id)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
        let controllers = book.map { [unowned self] in self.navigator.loaded(book: $0) }
        let title = book.map { $0.info.title }

        return Output(title: title,
                      controllers: controllers,
                      error: errorTracker.asDriver())
    }
}

extension BookViewModel {
    struct Output {
        let title: Driver<String>
        let controllers: Driver<[UIViewController]>
        let error: Driver<Error>
    }
}
