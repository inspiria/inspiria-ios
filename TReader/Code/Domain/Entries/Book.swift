//
//  Book.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

struct BookInfo: Codable {
    let id: Int
    let title: String
    let author: String
    let subtitle: String
    let version: String
    let year: Int
    let coverImageUrl: String
}

struct Book: Codable {
    let info: BookInfo
    let authors: [Author]
    let chapters: [Chapter]
}

struct FileProgress: Codable {
    let progress: Double
    let data: Data?
}
