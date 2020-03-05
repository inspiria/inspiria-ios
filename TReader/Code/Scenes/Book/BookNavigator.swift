//
//  BookNavigator.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

protocol BookNavigator {
    func to(book: BookInfo)
    func to(chapter: Chapter)
}

class DefaultBookNavigator: BookNavigator {
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
        let viewController: BookViewController = storyboard.instantiateViewController()
        viewController.viewModel = BookViewModel(booksUseCase: self.services.booksUseCase(),
                                                 navigator: self,
                                                 bookInfo: book)
        rootController.pushViewController(viewController, animated: true)
    }

    func to(chapter: Chapter) {
        let navigator = DefaultChapterNavigator(services: services, storyboard: storyboard, controller: rootController)
        navigator.to(chapter: chapter)
    }
}
