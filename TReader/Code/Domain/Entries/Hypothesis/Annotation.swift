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
//    let target: AnnotationTarget

    var quote: String {
        return "quote"
    }
}

struct AnnotationSearch: Codable {
    let limit: Int
    let user: String
    let quote: String?
}

struct AnnotationTarget: Codable {
    let source: String
//    let range: RangeSelector?
//    let position: TextPositionSelector?
//    let quote: TextQuoteSelector?
//
//    enum CodingKeys: String, CodingKey {
//      case source
//      case selector
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.source = try container.decode(String.self, forKey: .source)
//
//        let selectors = try container.decode([String.self: AnyObject], forKey: .selector)
//    }
//
//    func encode(to encoder: Encoder) throws {
//      var container = encoder.container(keyedBy: CodingKeys.self)
//      var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
//      try response.encode(self.bar, forKey: .bar)
//      try response.encode(self.baz, forKey: .baz)
//      try response.encode(self.friends, forKey: .friends)
//     }
}

enum AnnotationSelectorType: String {
    case range = "RangeSelector"
    case position = "TextPositionSelector"
    case quote = "TextQuoteSelector"
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
