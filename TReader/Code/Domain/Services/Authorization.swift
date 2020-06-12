//
//  Authorization.swift
//  TReader
//
//  Created by tadas on 2020-06-12.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

protocol Authorization {
    var token: String? { get }
}

class HypothesisAuthorization: Authorization {
    var token: String?

    func logIn(token: String) {
        self.token = token
    }

    func logOut() {
        self.token = nil
    }
}
