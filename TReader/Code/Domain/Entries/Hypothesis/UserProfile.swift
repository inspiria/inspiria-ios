//
//  UserProfile.swift
//  TReader
//
//  Created by tadas on 2020-06-12.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

struct UserProfile: Codable {
    let userId: String?
    let authority: String
    let preferences: [String: Bool]
    let features: [String: Bool]

    enum CodingKeys: String, CodingKey {
        case userId = "userid"
        case authority
        case preferences
        case features
    }
}

struct AccessTokenBody: Codable {
    let code: String
    let clientId: String
    let grantType: String = "authorization_code"

    enum CodingKeys: String, CodingKey {
        case code
        case clientId = "client_id"
        case grantType = "grant_type"
    }
}

struct RefreshAccessTokenBody: Codable {
    let refreshToken: String
    let grantType: String = "refresh_token"

    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
        case grantType = "grant_type"
    }
}

struct AccessToken: Codable {
    let tokenType: String
    let accessToken: String
    let expiresIn: Double
    let refreshToken: String
    let scope: String
    var refreshDate: Date

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
        case refreshDate = "refresh_date"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tokenType = try values.decode(String.self, forKey: .tokenType)
        accessToken = try values.decode(String.self, forKey: .accessToken)
        expiresIn = 59//try values.decode(Double.self, forKey: .expiresIn)
        refreshToken = try values.decode(String.self, forKey: .refreshToken)
        scope = try values.decode(String.self, forKey: .scope)
        refreshDate = (try? values.decode(Date.self, forKey: .refreshDate)) ?? Date()
    }

    func isValid() -> Bool {
        return -refreshDate.timeIntervalSinceNow + 60 < expiresIn
    }
}
