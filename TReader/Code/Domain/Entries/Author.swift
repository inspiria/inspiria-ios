//
//  Author.swift
//  TReader
//
//  Created by tadas on 2020-03-19.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

struct Author: Codable {
    let id: Int
    let name: String
    let nameSortable: String
    let degree: String
    let affiliation: String
    let pictureName: String
    let pictureUrl: String
    let bio: String
}
