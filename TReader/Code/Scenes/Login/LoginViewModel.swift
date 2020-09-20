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
import RxOptional

class LoginViewModel {
    let navigator: LoginNavigator
    let authUseCase: UserUseCase

    private let codeRelay = BehaviorRelay<String?>(value: nil)

    init (navigator: LoginNavigator, authUseCase: UserUseCase) {
        self.navigator = navigator
        self.authUseCase = authUseCase
    }

    func transform(input: Input) -> Output {
        let errorTracker = ErrorTracker()
        let activityTracker = ActivityIndicator()

        let authorize = input.authorize
            .do(onNext: navigator.toOAuth)

        let getToken = codeRelay
            .asDriver()
            .filterNil()
            .flatMap { code in
                self.authUseCase
                    .getToken(with: code)
                    .trackError(errorTracker)
                    .trackActivity(activityTracker)
                    .asDriverOnErrorJustComplete()
                    .flatMap { _ in
                        return DefaultUseCaseProvider.provider
                            .annotationsUseCase()
                            .getUserProfile()
                            .trackError(errorTracker)
                            .trackActivity(activityTracker)
                            .mapToVoid()
                            .asDriverOnErrorJustComplete()
                    }
            }
            .do(onNext: self.authUseCase.skipLogin)

        let skipAuthorize = input.skipAuthorize
            .do(onNext: { [unowned self] in
                self.authUseCase.skipLogin()
            })

        return Output(authorize: authorize,
                      getToken: getToken,
                      skipAuthorize: skipAuthorize,
                      error: errorTracker.asDriver(),
                      activity: activityTracker.asDriver())
    }

    func logIn(code: String) {
        codeRelay.accept(code)
    }
}

extension LoginViewModel {
    struct Input {
        let authorize: Driver<Void>
        let skipAuthorize: Driver<Void>
    }
    struct Output {
        let authorize: Driver<Void>
        let getToken: Driver<Void>
        let skipAuthorize: Driver<Void>
        let error: Driver<Error>
        let activity: Driver<Bool>
    }
}
