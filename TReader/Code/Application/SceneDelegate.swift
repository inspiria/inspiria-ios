//
//  SceneDelegate.swift
//  TReader
//
//  Created by tadas on 2020-02-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var rootNavigator: BooksListNavigator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard (scene as? UIWindowScene) != nil else { return }

        if let storyboard = session.configuration.storyboard {
            guard let rootController = window?.rootViewController as? UITabBarController,
                let navigationController = storyboard
                    .instantiateViewController(withIdentifier: "BooksListNavigationController") as? UINavigationController else { return }

            rootController.setViewControllers([navigationController], animated: false)
            rootNavigator = DefaultBooksListNavigator(services: DefaultUseCaseProvider.provider,
                                                      storyboard: storyboard,
                                                      controller: navigationController)
            rootNavigator?.toList()
        }
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
        print(URLContexts)
    }

}
