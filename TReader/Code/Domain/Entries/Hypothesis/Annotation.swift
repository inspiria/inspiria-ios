//
//  Annotation.swift
//  TReader
//
//  Created by tadas on 2020-06-12.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

struct AnnotationResponse: Codable {
    let total: Int
    let rows: [Annotation]
}

struct Annotation: Codable {
    let id: String
    let created: Date
    let updated: Date
    let user: String
    let uri: String
    let text: String
    let tags: [String]
    let group: String
    let target: [AnnotationTarget]

    var quote: String {
        for tar in target {
            for sel in tar.selector {
                if let quote = sel.exact {
                    return quote
                }
            }
        }
        return ""
    }
}

struct AnnotationSearch: Codable {
    let limit: Int
    let user: String
    let quote: String?
}

struct AnnotationTarget: Codable {
    let source: String
    let selector: [AnnotationSelector]

}

struct AnnotationSelector: Codable {
    enum `Type`: String, Codable {
        case range = "RangeSelector"
        case position = "TextPositionSelector"
        case quote = "TextQuoteSelector"
    }
    let type: `Type`
    let exact: String?
}

struct RangeSelector: Codable {
    let endOffset: Int
    let startOffset: Int
    let endContainer: String
    let startContainer: String
}

struct TextPositionSelector: Codable {
    let end: Int
    let start: Int
}

struct TextQuoteSelector: Codable {
    let exact: String
    let prefix: String
    let suffix: String
}
