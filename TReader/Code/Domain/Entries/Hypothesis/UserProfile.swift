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
    let expiresIn: Int
    let refreshToken: String
    let scope: String

    enum CodingKeys: String, CodingKey {
        case tokenType = "token_type"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope
    }
}
