//
//  LoginViewModel.swift
//  TReader
//
//  Created by tadas on 2020-07-31.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel {
    let navigator: LoginNavigator
    let authUseCase: OAuthUseCase

    init (navigator: LoginNavigator, authUseCase: OAuthUseCase) {
        self.navigator = navigator
        self.authUseCase = authUseCase
    }

    func transform(input: Input) -> Output {
        let authorize = input.authorize
            .do(onNext: navigator.toOAuth)

        let skipAuthorize = input.skipAuthorize
            .do(onNext: navigator.toApp)

        return Output(authorize: authorize, skipAuthorize: skipAuthorize)
    }
}

extension LoginViewModel {
    struct Input {
        let authorize: Driver<Void>
        let skipAuthorize: Driver<Void>
    }
    struct Output {
        let authorize: Driver<Void>
        let skipAuthorize: Driver<Void>
    }
}
