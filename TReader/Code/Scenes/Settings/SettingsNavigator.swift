//
//  SettingsNavigator.swift
//  TReader
//
//  Created by tadas on 2020-09-19.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

protocol SettingsNavigator {
    func toSettings()
}

class DefaultSettingsNavigator: SettingsNavigator {
    private let services: UseCaseProvider
    private let storyboard: UIStoryboard
    private let rootController: UINavigationController

    init(services: UseCaseProvider,
         storyboard: UIStoryboard,
         controller: UINavigationController) {
        self.services = services
        self.storyboard = storyboard
        self.rootController = controller
    }

    func toSettings() {
        let controller: SettingsViewController = storyboard.instantiateViewController()
        controller.viewModel = SettingsViewModel(userUseCase: services.authUseCase(), navigator: self)
        rootController.viewControllers = [controller]
    }
}
