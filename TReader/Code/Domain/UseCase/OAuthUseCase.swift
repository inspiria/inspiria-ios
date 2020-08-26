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

enum OAuthError: LocalizedError {
    case emptyCode

    var errorDescription: String? {
        switch self {
        case .emptyCode: return "Authentication code should not be empty!"
        }
    }
}

protocol OAuthUseCase {
    var loggedIn: Driver <Bool> { get }
    var showLogIn: Driver <Bool> { get }
    var accessToken: Driver <String?> { get }

    var oAuthUrl: URL { get }

    func skipLogin()
    func getToken(with code: String) -> Single<AccessToken>
}

class HypothesisOAuthUseCase: OAuthUseCase {
    private let clientId = "4af80306-d349-11ea-9e36-ef8ded55ca92"
    fileprivate lazy var accessTokenRelay = BehaviorRelay<AccessToken?>(value: latestAccessToken())
    fileprivate lazy var showLogInRelay = BehaviorRelay<Bool>(value: latestShowLogIn())

    private let networkService: NetworkService
    private let disposeBag = DisposeBag()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    var accessToken: Driver<String?> { return accessTokenRelay.asDriver().map { $0?.accessToken } }
    var loggedIn: Driver<Bool> { return accessTokenRelay.asDriver().map { $0 != nil } }
    var showLogIn: Driver<Bool> { return showLogInRelay.asDriver() }

    var oAuthUrl: URL {
        let str = "\(networkService.url)/oauth/authorize?client_id=\(clientId)&response_type=code"
        return URL(string: str)!
    }

    func skipLogin() {
        set(showLogIn: false)
    }

    func getToken(with code: String) -> Single<AccessToken> {
        guard code.count > 0 else { return Single<AccessToken>.error(OAuthError.emptyCode) }
        let body = AccessTokenBody(code: code, clientId: clientId)
        let response: Single<AccessToken> = networkService.request(path: "api/token", method: .post, contentType: .urlencoded, data: body)
        return response.do( onSuccess: { [unowned self] token in
            self.set(token: token)
            self.set(showLogIn: false)
        })
    }

    func refreshToken(accessToke: String) {

    }
}

fileprivate extension HypothesisOAuthUseCase {
    private static let kSessionDataKey = "session-data-key"
    private static let kShowLogInKey = "show-log-in-key"

    func latestAccessToken() -> AccessToken? {
        guard let data = UserDefaults.standard.data(forKey: HypothesisOAuthUseCase.kSessionDataKey) else { return nil }
        return try? AccessToken(data: data)
    }

    func set(token: AccessToken?) {
        accessTokenRelay.accept(token)
        let data = token?.jsonDataOrNil()
        UserDefaults.standard.set(data, forKey: HypothesisOAuthUseCase.kSessionDataKey)
        UserDefaults.standard.synchronize()
    }

    func latestShowLogIn() -> Bool {
        guard UserDefaults.standard.value(forKey: HypothesisOAuthUseCase.kShowLogInKey) != nil else { return true }
        return UserDefaults.standard.bool(forKey: HypothesisOAuthUseCase.kShowLogInKey)
    }

    func set(showLogIn: Bool) {
        showLogInRelay.accept(showLogIn)
        UserDefaults.standard.set(showLogIn, forKey: HypothesisOAuthUseCase.kShowLogInKey)
        UserDefaults.standard.synchronize()
    }
}
