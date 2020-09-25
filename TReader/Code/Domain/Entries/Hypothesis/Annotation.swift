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
    var id: String { get }
    var updated: Date { get }
    var uri: String { get }
    var text: String { get }
    var quoteText: String { get }
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
}

extension Annotation {
    var quoteText: String { return quote?.exact ?? "" }
    var quote: TextQuoteSelector? {
        let res = target.flatMap { ann -> [TextQuoteSelector] in
            let res = ann.selector.compactMap { sel -> TextQuoteSelector? in
                if case let AnnotationSelector.quote(selector) = sel {
                    return selector
                }
                return nil
            }
            return res
        }
        return res.first
    }

    func jsAnnotation() -> JSAnnotation? {
        guard let quote = quote else { return nil }
        return JSAnnotation(id: id, exact: quote.exact, prefix: quote.prefix, suffix: quote.suffix)
    }
}

struct AnnotationCreate: Codable, Annotationable {
    var id: String = ""
    var updated: Date = Date()
    let uri: String
    var text: String
    let quoteText: String
    let target: [AnnotationTarget]

    init(uri: String, text: String, annotation: JSAnnotation) {
        self.uri = uri
        self.text = text
        self.quoteText = annotation.exact
        let selector = AnnotationSelector.quote(TextQuoteSelector(exact: annotation.exact,
                                                                  prefix: annotation.prefix,
                                                                  suffix: annotation.suffix))
        self.target = [AnnotationTarget(source: "", selector: [selector])]
    }
}

struct AnnotationUpdate: Codable {
    var id: String
    var updated: Date
    let text: String
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
    var type: AnnotationSelector.`Type` = .range
    let endOffset: Int
    let startOffset: Int
    let endContainer: String
    let startContainer: String
}

struct TextPositionSelector: Codable {
    var type: AnnotationSelector.`Type` = .position
    let end: Int
    let start: Int
}

struct TextQuoteSelector: Codable {
    var type: AnnotationSelector.`Type` = .quote
    let exact: String
    let prefix: String
    let suffix: String
}

struct JSAnnotation: Codable {
    let id: String?
    let exact: String
    let prefix: String
    let suffix: String
}
