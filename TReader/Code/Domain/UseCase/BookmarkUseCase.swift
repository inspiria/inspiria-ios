//
//  BookmarkUseCase.swift
//  TReader
//
//  Created by tadas on 2020-05-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BookmarkUseCase {
    func getBookmarks(book: Int) -> Observable<[Bookmark]>
    func add(bookmark: Bookmark)
    func hasBookmark(book: Int, chapter: Int) -> Bool
    func removeBookmark(book: Int, chapter: Int)
}

class DefaultBookmarkUseCase: BookmarkUseCase {
    private let bookmarks = BehaviorRelay<[Bookmark]>(value: [])

    func getBookmarks(book: Int) -> Observable<[Bookmark]> {
        return bookmarks.map { $0.filter { $0.bookId == book } }
    }

    func add(bookmark: Bookmark) {
        bookmarks.accept(bookmarks.value + [bookmark])
    }

    func hasBookmark(book: Int, chapter: Int) -> Bool {
        let val = bookmarks.value.first { $0.bookId == book && $0.chapterId == chapter } != nil
        return val
    }

    func removeBookmark(book: Int, chapter: Int) {
        var values = bookmarks.value
        values.removeAll { $0.bookId == book && $0.chapterId == chapter }
        bookmarks.accept(values)
    }
}
