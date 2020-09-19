//
//  JS.swift
//  TReader
//
//  Created by tadas on 2020-08-28.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Swift

struct JSAnnotation: Codable {
    let id: String?
    let exact: String
    let prefix: String
    let suffix: String
    let start: Int
    let end: Int
}
