//
//  Bookmark.swift
//  TReader
//
//  Created by tadas on 2020-05-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

struct Bookmark: Codable {
    let title: String
    let date: Date
    let bookId: Int
    let chapterId: Int
    let page: Int

    var id: String { "\(bookId)-\(chapterId)" }
}
