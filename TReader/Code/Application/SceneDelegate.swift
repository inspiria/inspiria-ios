//
//  SceneDelegate.swift
//  TReader
//
//  Created by tadas on 2020-02-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootNavigator: Any?

    private let auth = DefaultUseCaseProvider.provider.authUseCase()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard (scene as? UIWindowScene) != nil else { return }
        guard let storyboard = session.configuration.storyboard else { return }
        guard let rootController = window?.rootViewController as? UITabBarController else { return }
        guard let navigationController = storyboard
            .instantiateViewController(withIdentifier: "BooksListNavigationController") as? UINavigationController else { return }

        rootController.setViewControllers([navigationController], animated: false)

        auth.showLogIn
            .drive(onNext: { [unowned self] show in
                if show {
                    let navigator = DefaultLoginNavigator(services: DefaultUseCaseProvider.provider,
                                                          storyboard: storyboard,
                                                          controller: rootController)
                    navigator.toLogin()
                    self.rootNavigator = navigator
                } else {
                    let navigator  = DefaultBooksListNavigator(services: DefaultUseCaseProvider.provider,
                                                               storyboard: storyboard,
                                                               controller: navigationController)
                    navigator.toList()
                    self.rootNavigator = navigator
                }
            })
            .disposed(by: rx.disposeBag)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let contexts = URLContexts.first
        guard let url = contexts?.url else { return }
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return }

        switch components.host {
        case "oauth":
            if let code = components.queryItems?.filter({ $0.name == "code" }).first?.value {
                print(code)
                guard let navigator  = rootNavigator as? DefaultLoginNavigator else { return }
                navigator.toApp(with: code)
            }
        default:
            print("nothing to do")
        }
    }

}
