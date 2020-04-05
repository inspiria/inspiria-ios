//
//  Chapters.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

struct Chapter: Codable {
    let id: Int
    let bookId: Int
    let fileName: String
    let shortName: String
    let title: String
    let orderNumber: Float
    let isSectionHeader: Bool
    let showNumber: Bool
    let showHeadings: Bool
    let lastUpdated: Date
    let parentId: Int?
    let copyrightOverride: String?
    let language: String
    let citation: String?
}
