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

struct Bookmark {
    let title: String
    let date: Date
    let pageNumber: Int
}

class BookmarksViewModel {
    let navigator: BookmarksNavigator

    init (navigator: BookmarksNavigator) {
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let bookmarks = Driver.just([
            Bookmark(title: "Chapter 1", date: Date().addingTimeInterval(-300), pageNumber: 25),
            Bookmark(title: "Chapter 2", date: Date().addingTimeInterval(-30000), pageNumber: 33),
            Bookmark(title: "Chapter 4", date:  Date().addingTimeInterval(-300000), pageNumber: 61),
            Bookmark(title: "Chapter 15", date: Date().addingTimeInterval(-500000), pageNumber: 55),
            Bookmark(title: "Chapter 19", date: Date().addingTimeInterval(-3000000), pageNumber: 125),
            Bookmark(title: "Chapter 123", date: Date().addingTimeInterval(-7000), pageNumber: 999),
            Bookmark(title: "Chapter 999", date: Date().addingTimeInterval(-70000), pageNumber: 3)
        ])
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
