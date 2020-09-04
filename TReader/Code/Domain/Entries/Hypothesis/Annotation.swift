//
//  Annotation.swift
//  TReader
//
//  Created by tadas on 2020-06-12.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

struct AnnotationSearch: Codable {
    let limit: Int
    let user: String
    let quote: String?
    let wildcardUri: String?

    enum CodingKeys: String, CodingKey {
        case limit, user, quote
        case wildcardUri = "wildcard_uri"
    }
}

struct AnnotationResponse: Codable {
    let total: Int
    let rows: [Annotation]
}

struct DeleteAnnotationResponse: Codable {
    let deleted: Bool
    let id: String
}

protocol Annotationable {
    var uri: String { get }
    var text: String { get }
    var created: Date { get }
    var target: [AnnotationTarget] { get }
}

struct Annotation: Codable, Annotationable {
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
        let res = target.flatMap { ann -> [String] in
            let res = ann.selector.compactMap { sel -> String? in
                if case let AnnotationSelector.quote(selector) = sel {
                    return selector.exact
                }
                return nil
            }
            return res
        }
        return res.first ?? ""
    }
}

struct NewAnnotation: Codable, Annotationable {
    let uri: String
    let text: String
    let created: Date
    let target: [AnnotationTarget]
}

struct AnnotationTarget: Codable {
    let source: String
    let selector: [AnnotationSelector]

}

enum AnnotationSelector: Codable {
    case range(RangeSelector)
    case quote(TextQuoteSelector)
    case position(TextPositionSelector)

    enum `Type`: String, Codable {
        case range = "RangeSelector"
        case quote = "TextQuoteSelector"
        case position = "TextPositionSelector"
    }

    enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let type = try values.decode(Type.self, forKey: .type)
        switch type {
        case .range:    self = try .range(RangeSelector(from: decoder))
        case .quote:    self = try .quote(TextQuoteSelector(from: decoder))
        case .position: self = try .position(TextPositionSelector(from: decoder))
        }
    }

    func encode(to encoder: Encoder) throws {
        switch self {
        case .range(let selector): try selector.encode(to: encoder)
        case .quote(let selector): try selector.encode(to: encoder)
        case .position(let selector): try selector.encode(to: encoder)
        }
    }
}

struct RangeSelector: Codable {
    let type: AnnotationSelector.`Type` = .range
    let endOffset: Int
    let startOffset: Int
    let endContainer: String
    let startContainer: String
}

struct TextPositionSelector: Codable {
    let type: AnnotationSelector.`Type` = .position
    let end: Int
    let start: Int
}

struct TextQuoteSelector: Codable {
    let type: AnnotationSelector.`Type` = .quote
    let exact: String
    let prefix: String
    let suffix: String
}
