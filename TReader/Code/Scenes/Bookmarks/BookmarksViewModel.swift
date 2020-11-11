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
    let book: Book

    init (book: Book, useCase: BookmarkUseCase, navigator: BookmarksNavigator) {
        self.book = book
        self.useCase = useCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let bookmarks = useCase.getBookmarks(book: book.info.id)
            .asDriver(onErrorJustReturn: [])
        let selected = input.itemSelected
            .withLatestFrom(bookmarks) { $1[$0] }
            .map { [unowned self] in ($0.chapterId, self.book) }
            .do(onNext: navigator.to)
            .mapToVoid()

        return Output(bookmarks: bookmarks, selected: selected)
    }
}

extension BookmarksViewModel {
    struct Input {
        let itemSelected: Driver<Int>
    }
    struct Output {
        let bookmarks: Driver<[Bookmark]>
        let selected: Driver<Void>
    }
}
