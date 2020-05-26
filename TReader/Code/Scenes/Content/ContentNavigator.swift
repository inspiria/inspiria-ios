//
//  BookNavigator.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

protocol ContentNavigator {
    func to(book: BookInfo)
    func to(chapterId: Int, of book: Book)
}

class ContentBookNavigator: ContentNavigator {
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

    func to(book: BookInfo) {
        let contentController: ContentViewController = storyboard.instantiateViewController()
        contentController.viewModel = ContentViewModel(booksUseCase: self.services.booksUseCase(),
                                                       navigator: self,
                                                       bookInfo: book)
        let vc2 = UITableViewController()
        let vc3 = UIViewController()

        vc2.view.backgroundColor = .white
        vc3.view.backgroundColor = .white

        contentController.tabBarItem = UITabBarItem(title: "Outline", image: nil, tag: 0)
        vc2.tabBarItem = UITabBarItem(title: "Notes", image: nil, tag: 0)
        vc3.tabBarItem = UITabBarItem(title: "Bookmarks", image: nil, tag: 0)

        let tabController = TabBatViewController([contentController, vc2, vc3])
        rootController.pushViewController(tabController, animated: true)
    }

    func to(chapterId: Int, of book: Book) {
        let navigator = DefaultChaptersNavigator(services: services, storyboard: storyboard, controller: rootController)
        navigator.to(chapterId: chapterId, of: book)
    }
}
