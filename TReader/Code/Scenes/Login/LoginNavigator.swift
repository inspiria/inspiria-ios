//
//  LoginNavigator.swift
//  TReader
//
//  Created by tadas on 2020-07-31.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import SafariServices

import RxCocoa
import RxSwift
import RxViewController

protocol LoginNavigator {
    func toLogin()
    func toOAuth()
    func toApp()
    func toApp(with code: String)
}

class DefaultLoginNavigator: NSObject, LoginNavigator {
    private let services: UseCaseProvider
    private let storyboard: UIStoryboard
    private let rootController: UIViewController

    init(services: UseCaseProvider,
         storyboard: UIStoryboard,
         controller: UIViewController) {
        self.services = services
        self.storyboard = storyboard
        self.rootController = controller
    }

    func toLogin() {
        let controller: LoginViewController = storyboard.instantiateViewController()
        controller.viewModel = LoginViewModel(navigator: self, authUseCase: services.authUseCase())
        controller.modalPresentationStyle = .overCurrentContext

        rootController.rx.viewDidAppear
            .subscribe { [unowned self] _ in
                self.rootController.present(controller, animated: false, completion: nil)
        }
        .disposed(by: rx.disposeBag)
    }

    func toOAuth() {
        let url = services.authUseCase().oAuthUrl

        let configuration = SFSafariViewController.Configuration()
        configuration.barCollapsingEnabled = true
        configuration.entersReaderIfAvailable = true

        let safari = SFSafariViewController(url: url, configuration: configuration)
        safari.modalPresentationStyle = .overFullScreen
        safari.delegate = self
        rootController.presentedViewController?.present(safari, animated: true, completion: nil)
    }

    func toApp() {
        services.authUseCase().getToken(code: "")
        rootController.dismiss(animated: true, completion: nil)
    }

    func toApp(with code: String) {
        services.authUseCase().getToken(code: code)
        rootController.dismiss(animated: true, completion: nil)
    }
}

extension DefaultLoginNavigator: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
