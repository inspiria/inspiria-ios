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
    case invalidSession

    var errorDescription: String? {
        switch self {
        case .emptyCode: return "Authentication code should not be empty!"
        case .invalidSession: return "No login session is stored"
        }
    }
}

protocol Authorization {
    func accessToken() -> Single<String?>
}

protocol UserUseCase {
    var isLoggedIn: Driver <Bool> { get }
    var doShowLogIn: Driver <Bool> { get }

    var oAuthUrl: URL { get }

    func showLogIn()
    func logOut()
    func skipLogin()
    func getToken(with code: String) -> Single<AccessToken>
    func accessToken() -> Single<String?>
}

class HypothesisUserUseCase: UserUseCase, Authorization {
    private let clientId = "4af80306-d349-11ea-9e36-ef8ded55ca92"
    fileprivate lazy var accessTokenRelay = BehaviorRelay<AccessToken?>(value: latestAccessToken())
    fileprivate lazy var showLogInRelay = BehaviorRelay<Bool>(value: latestShowLogIn())

    private let networkService: NetworkService
    private let disposeBag = DisposeBag()

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    var isLoggedIn: Driver<Bool> { accessTokenRelay.asDriver().map { $0 != nil } }
    var doShowLogIn: Driver<Bool> { showLogInRelay.asDriver() }

    var oAuthUrl: URL {
        let str = "\(networkService.url)/oauth/authorize?client_id=\(clientId)&response_type=code"
        return URL(string: str)!
    }

    func showLogIn() {
        self.set(showLogIn: true)
    }

    func logOut() {
        self.set(token: nil)
    }

    func skipLogin() {
        set(showLogIn: false)
    }

    func getToken(with code: String) -> Single<AccessToken> {
        guard code.count > 0 else { return Single<AccessToken>.error(OAuthError.emptyCode) }
        let body = AccessTokenBody(code: code, clientId: clientId)
        let response: Single<AccessToken> = networkService.request(path: "api/token", method: .post, contentType: .urlencoded, data: body)
        return response
            .do(onSuccess: { [unowned self] token in
                self.set(token: token)
            })
    }

    private func refreshToken(with refreshToken: String) -> Single<AccessToken> {
        let body = RefreshAccessTokenBody(refreshToken: refreshToken)
        let response: Single<AccessToken> = networkService.request(path: "api/token", method: .post, contentType: .urlencoded, data: body)
        return response
            .do(onSuccess: { [unowned self] token in
                self.set(token: token)
                }, onError: {[unowned self] _ in
                    //TODO: Handle token refresh failure
                    self.set(token: nil)
                    self.set(showLogIn: true)
                })
    }

    func accessToken() -> Single<String?> {
        guard let token = accessTokenRelay.value  else { return Single<String?>.just(nil) }
        if token.isValid() {
            return Single<String?>.just(token.accessToken)
        }
        return refreshToken(with: token.refreshToken).map { $0.accessToken }
    }
}

fileprivate extension HypothesisUserUseCase {
    private static let kSessionDataKey = "session-data-key"
    private static let kShowLogInKey = "show-log-in-key"

    func latestAccessToken() -> AccessToken? {
        guard let data = UserDefaults.standard.data(forKey: HypothesisUserUseCase.kSessionDataKey) else { return nil }
        return try? AccessToken(data: data)
    }

    func set(token: AccessToken?) {
        accessTokenRelay.accept(token)
        let data = token?.jsonDataOrNil()
        UserDefaults.standard.set(data, forKey: HypothesisUserUseCase.kSessionDataKey)
        UserDefaults.standard.synchronize()
    }

    func latestShowLogIn() -> Bool {
        guard UserDefaults.standard.value(forKey: HypothesisUserUseCase.kShowLogInKey) != nil else { return true }
        return UserDefaults.standard.bool(forKey: HypothesisUserUseCase.kShowLogInKey)
    }

    func set(showLogIn: Bool) {
        showLogInRelay.accept(showLogIn)
        UserDefaults.standard.set(showLogIn, forKey: HypothesisUserUseCase.kShowLogInKey)
        UserDefaults.standard.synchronize()
    }
}
