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
    func to(chapterId: Int, of book: Book)
}

class DefaultSearchBookNavigator: SearchBookNavigator {
    private let services: UseCaseProvider
    private let storyboard: UIStoryboard
    private let rootController: UINavigationController
    private let chaptersNavigator: ChaptersNavigator

    init(services: UseCaseProvider,
         storyboard: UIStoryboard,
         controller: UINavigationController,
         chaptersNavigator: ChaptersNavigator) {
        self.services = services
        self.storyboard = storyboard
        self.rootController = controller
        self.chaptersNavigator = chaptersNavigator
    }

    func toSearch(book: Book) {
        let viewController: SearchBookViewController = storyboard.instantiateViewController()
        viewController.viewModel = SearchBookViewModel(book: book, searchUseCase: services.bookSearchUseCase(), navigator: self)
        rootController.present(viewController, animated: true, completion: nil)
    }

    func to(chapterId: Int, of book: Book) {
        chaptersNavigator.to(chapterId: chapterId, of: book)
        rootController.dismiss(animated: true, completion: nil)
    }
}
