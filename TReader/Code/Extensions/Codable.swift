//
//  Codable.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

private let dateFormatterUTF: DateFormatter = {
    let frm = DateFormatter()
    frm.timeZone = TimeZone(secondsFromGMT: 0)
    frm.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    return frm
}()

private let dateFormatterLocal: DateFormatter = {
    let frm = DateFormatter()
    frm.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return frm
}()

enum CodableError: Error {
    case error
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization
            .jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }

    func json() throws -> String {
        guard let jsonString = String(data: try jsonData(), encoding: .utf8) else { throw CodableError.error }
        return jsonString
    }

    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(dateFormatterUTF)
        return try encoder.encode(self)
    }

    func jsonDataOrNil() -> Data? {
        do {
            return try jsonData()
        } catch {
            return nil
        }
    }

    func jsonOrNil() -> String? {
        do {
            return try json()
        } catch {
            return nil
        }
    }
}

extension Decodable {
    init(json: String) throws {
        guard let jsonData = json.data(using: .utf8) else { throw CodableError.error }
        try self.init(data: jsonData)
    }

    init(data: Data) throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = dateFormatterUTF.date(from: dateString) { return date }
            if let date = dateFormatterLocal.date(from: dateString) { return date }

            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Cannot decode date string \(dateString)")
        }
        self = try decoder.decode(Self.self, from: data)
    }

    init(dict: Any) throws {
        let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [])
        guard let jsonString = String(data: jsonData, encoding: .utf8) else { throw CodableError.error }
        try self.init(json: jsonString)
    }

    static func with(json: String) -> Self? {
        do {
            return try Self(json: json)
        } catch {
            return nil
        }
    }
}
