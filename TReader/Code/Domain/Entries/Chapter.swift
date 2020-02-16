//
//  Chapters.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

struct Chapter: Codable {
    let bookId: Int
    let id: Int
    let title: String
    let language: String
    let shortName: String
    let order: Float
    let text: String
    let textProcessed: String
    let citation: String?
    let sectionHeaders: String
}
