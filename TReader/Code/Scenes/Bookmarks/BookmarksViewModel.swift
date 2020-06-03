//
//  BookmarksViewModel.swift
//  TReader
//
//  Created by tadas on 2020-05-30.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BookmarksViewModel {
    let navigator: BookmarksNavigator
    let useCase: BookmarkUseCase
    let bookId: Int

    init (bookId: Int, useCase: BookmarkUseCase, navigator: BookmarksNavigator) {
        self.bookId = bookId
        self.useCase = useCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let bookmarks = useCase.getBookmarks(book: bookId)
            .asDriver(onErrorJustReturn: [])

        return Output(bookmarks: bookmarks)
    }
}

extension BookmarksViewModel {
    struct Input {
    }
    struct Output {
        let bookmarks: Driver<[Bookmark]>
    }
}
