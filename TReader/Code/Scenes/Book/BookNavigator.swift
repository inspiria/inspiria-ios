//
//  BookNavigator.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

protocol BookNavigator {
    func toBook(id: Int)
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

    func toBook(id: Int) {
        let viewController = storyboard.instantiateViewController(withIdentifier: BookViewController.identifier) as! BookViewController
        viewController.viewModel = BookViewModel(bookUseCase: self.services.bookUseCase(),
                                                 navigator: self,
                                                 bookId: id)
        rootController.pushViewController(viewController, animated: true)
    }
}
