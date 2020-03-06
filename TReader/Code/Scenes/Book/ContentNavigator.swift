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
    func to(chapter: Chapter)
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
        let viewController: ContentViewController = storyboard.instantiateViewController()
        viewController.viewModel = ContentViewModel(booksUseCase: self.services.booksUseCase(),
                                                 navigator: self,
                                                 bookInfo: book)
        rootController.pushViewController(viewController, animated: true)
    }

    func to(chapter: Chapter) {
        let navigator = DefaultChapterNavigator(services: services, storyboard: storyboard, controller: rootController)
        navigator.to(chapter: chapter)
    }
}
