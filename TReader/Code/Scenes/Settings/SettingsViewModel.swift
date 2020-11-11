//
//  SettingsViewModel.swift
//  TReader
//
//  Created by tadas on 2020-09-19.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingsViewModel {
    let navigator: SettingsNavigator
    let userUseCase: UserUseCase

    init (userUseCase: UserUseCase, navigator: SettingsNavigator) {
        self.navigator = navigator
        self.userUseCase = userUseCase
    }

    func transform(input: Input) -> Output {
        let logInAction = input.logInPressed
            .do(onNext: userUseCase.showLogIn)
        let logOutAction = input.logOutPressed
            .do(onNext: userUseCase.logOut)

        return Output(isLoggedIn: userUseCase.isLoggedIn,
                      logInAction: logInAction,
                      logOutAction: logOutAction)
    }
}

extension SettingsViewModel {
    struct Input {
        let logInPressed: Driver<Void>
        let logOutPressed: Driver<Void>
    }
    struct Output {
        let isLoggedIn: Driver<Bool>

        let logInAction: Driver<Void>
        let logOutAction: Driver<Void>
    }
}
