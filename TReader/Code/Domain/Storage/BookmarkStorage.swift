//
//  BookmarkStorage.swift
//  TReader
//
//  Created by tadas on 2020-05-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BookmarkStorage {
    func getBookmarks(for book: Int) -> Observable<[Bookmark]>
    func hasBookmark(for book: Int, chapter: Int) -> Bool
    func addBookmark(for book: Int, chapter: Int, title: String, page: Int)
    func removeBookmark(for book: Int, chapter: Int)
}

class DefaultBookmarkStorage: BookmarkStorage {
    func getBookmarks(for book: Int) -> Observable<[Bookmark]> {
        Observable.just([
            Bookmark(title: "Chapter 1", date: Date().addingTimeInterval(-300), bookId: 1, chapterId: 1),
            Bookmark(title: "Chapter 2", date: Date().addingTimeInterval(-30000), bookId: 1, chapterId: 1),
            Bookmark(title: "Chapter 4", date: Date().addingTimeInterval(-300000), bookId: 1, chapterId: 1),
            Bookmark(title: "Chapter 15", date: Date().addingTimeInterval(-500000), bookId: 1, chapterId: 1),
            Bookmark(title: "Chapter 19", date: Date().addingTimeInterval(-3000000), bookId: 1, chapterId: 1),
            Bookmark(title: "Chapter 123", date: Date().addingTimeInterval(-7000), bookId: 1, chapterId: 1),
            Bookmark(title: "Chapter 999", date: Date().addingTimeInterval(-70000), bookId: 1, chapterId: 1)
        ])
    }

    func hasBookmark(for book: Int, chapter: Int) -> Bool { return Bool.random() }
    func addBookmark(for book: Int, chapter: Int, title: String, page: Int) { }
    func removeBookmark(for book: Int, chapter: Int) { }
}
