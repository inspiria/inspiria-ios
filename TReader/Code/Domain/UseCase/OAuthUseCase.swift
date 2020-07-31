//
//  OAuthUseCase.swift
//  TReader
//
//  Created by tadas on 2020-07-31.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

enum TokenType: String {
    case refresh, access
}

protocol OAuthUseCase {
    var loggedIn: Driver <Bool> { get }
    var showLogIn: Driver <Bool> { get }
    var refreshToken: Driver <String?> { get }
    var accessToken: Driver <String?> { get }

    var oAuthUrl: URL { get }

    func getToken(code: String)
}

class HypothesisOAuthUseCase: OAuthUseCase {
    fileprivate lazy var refreshTokenRelay = BehaviorRelay<String?>(value: latestValue(.refresh))
    fileprivate lazy var accessTokenRelay = BehaviorRelay<String?>(value: latestValue(.access))
    fileprivate lazy var loggedInRelay = BehaviorRelay<Bool>(value: false)
    fileprivate lazy var showLogInRelay = BehaviorRelay<Bool>(value: true)

    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    var refreshToken: Driver<String?> { return refreshTokenRelay.asDriver() }
    var accessToken: Driver<String?> { return accessTokenRelay.asDriver() }
    var loggedIn: Driver<Bool> { return loggedInRelay.asDriver() }
    var showLogIn: Driver<Bool> { return showLogInRelay.asDriver() }

    private func latestValue(_ type: TokenType) -> String? {
        return UserDefaults.standard.string(forKey: type.rawValue)
    }

    fileprivate func set(_ type: TokenType, token: String?) {
        switch type {
        case .access:
            accessTokenRelay.accept(token)
        case .refresh:
            refreshTokenRelay.accept(token)
        }

        UserDefaults.standard.set(token, forKey: type.rawValue)
        UserDefaults.standard.synchronize()
    }

    var oAuthUrl: URL {
        let clientId = "4af80306-d349-11ea-9e36-ef8ded55ca92"
        let str = "\(networkService.url)oauth/authorize?client_id=\(clientId)&response_type=code"
        return URL(string: str)!
    }

    func getToken(code: String) {
        showLogInRelay.accept(false)
    }

    func refreshToken(accessToke: String) {

    }
}
