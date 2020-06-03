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
}

class DefaultBookNavigator: BookNavigator, ContentNavigator, AnnotationNavigator, BookmarksNavigator {
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

        let notesController: AnnotationViewController = storyboard.instantiateViewController()
        notesController.viewModel = AnnotationViewModel(navigator: self)

        let bookmarksController: BookmarksViewController = storyboard.instantiateViewController()
        bookmarksController.viewModel = BookmarksViewModel(bookId: book.id,
                                                           useCase: services.bookmarkUseCase(),
                                                           navigator: self)

        contentController.tabBarItem = UITabBarItem(title: "Outline", image: nil, tag: 0)
        notesController.tabBarItem = UITabBarItem(title: "Notes", image: nil, tag: 0)
        bookmarksController.tabBarItem = UITabBarItem(title: "Bookmarks", image: nil, tag: 0)

        let tabController = BookViewController([contentController, notesController, bookmarksController])
        rootController.pushViewController(tabController, animated: true)
    }

    func to(chapterId: Int, of book: Book) {
        let navigator = DefaultChaptersNavigator(services: services,
                                                 storyboard: storyboard,
                                                 controller: rootController)
        navigator.to(chapterId: chapterId, of: book)
    }

    func toNotes() {
        //PRESENT VIEW CONTROLLER
        fatalError("Not implemented")
    }

    func toBookmarks() {
        //PRESENT VIEW CONTROLLER
        fatalError("Not implemented")
    }
}
