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
