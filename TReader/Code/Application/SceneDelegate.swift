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
    var navigators: [Any]?

    private let auth = DefaultUseCaseProvider.provider.authUseCase()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let storyboard = session.configuration.storyboard else { return }
        guard (scene as? UIWindowScene) != nil else { return }
        guard let rootController = window?.rootViewController as? UITabBarController else { return }

        let settingsController = UINavigationController()
        let booksController = UINavigationController()
        let annotationsController = UINavigationController()

        settingsController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "Settings"), tag: 0)
        booksController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "Library"), tag: 1)
        annotationsController.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "Notes"), tag: 2)

        rootController.setViewControllers([settingsController, booksController, annotationsController], animated: false)
        rootController.selectedIndex = 1

        auth.doShowLogIn
            .do(onNext: { [unowned self] show in
                if show {
                    self.loadLogin(with: storyboard, rootController: rootController)
                } else {
                    rootController.dismiss(animated: true, completion: nil)
                    self.loadMain(with: storyboard,
                                  settingsController: settingsController,
                                  booksController: booksController,
                                  annotationsController: annotationsController)
                }
            })
            .drive()
            .disposed(by: rx.disposeBag)
    }

    func openSettings() {
        if let rootController = window?.rootViewController as? UITabBarController {
            rootController.selectedIndex = 0
        }
    }

    func loadLogin(with storyboard: UIStoryboard, rootController: UITabBarController) {
        let provider = DefaultUseCaseProvider.provider
        let navigator = DefaultLoginNavigator(services: provider,
                                              storyboard: storyboard,
                                              controller: rootController)
        navigator.toLogin()
        self.navigators = [navigator]
    }

    func loadMain(with storyboard: UIStoryboard,
                  settingsController: UINavigationController,
                  booksController: UINavigationController,
                  annotationsController: UINavigationController) {

        let provider = DefaultUseCaseProvider.provider

        let settingsNavigator  = DefaultSettingsNavigator(services: provider, storyboard: storyboard, controller: settingsController)
        settingsNavigator.toSettings()

        let booksNavigator  = DefaultBooksListNavigator(services: provider, storyboard: storyboard, controller: booksController)
        booksNavigator.toList()

        let annotationsNavigator  = DefaultAnnotationsLibratyNavigator(services: provider, storyboard: storyboard, controller: annotationsController)
        annotationsNavigator.toAnnotations()

        self.navigators = [settingsNavigator, booksNavigator, annotationsNavigator]
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
                guard let navigator  = navigators?.compactMap({ $0 as? LoginNavigator }).first else { return }
                navigator.toApp(with: code)
            }
        default:
            print("nothing to do")
        }
    }
}
