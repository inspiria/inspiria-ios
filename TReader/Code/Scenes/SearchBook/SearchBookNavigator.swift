//
//  SearchBookNavigator.swift
//  TReader
//
//  Created by tadas on 2020-09-04.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

protocol SearchBookNavigator {
    func toSearch(book: Book)
}

class DefaultSearchBookNavigator: SearchBookNavigator {
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

    func toSearch(book: Book) {
        let viewController: SearchBookViewController = storyboard.instantiateViewController()
        viewController.viewModel = SearchBookViewModel(navigator: self)
        rootController.present(viewController, animated: true, completion: nil)
    }
}
