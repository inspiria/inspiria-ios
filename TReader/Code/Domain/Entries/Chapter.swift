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
    let title: String
    let language: String
    let shortName: String
    let order: Float
    let citation: String?
    let sectionHeader: Int
    let showNumber: Int
    let text: String
    let textProcessed: String
    let sectionHeaders: String
}
