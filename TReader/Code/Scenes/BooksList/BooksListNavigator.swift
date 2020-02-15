//
//  BooksListNavigator.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

protocol BooksListNavigator {
    func toList()
    func to(book: Book)
}

class DefaultBooksListNavigator: BooksListNavigator {
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

    func toList() {
        let controller = storyboard.instantiateViewController(withIdentifier: BooksListViewController.identifier) as! BooksListViewController
        controller.viewModel = BooksListViewModel(booksUseCase: services.booksUseCase())

        rootController.viewControllers = [controller]
    }

    func to(book: Book) {

    }
    
}
