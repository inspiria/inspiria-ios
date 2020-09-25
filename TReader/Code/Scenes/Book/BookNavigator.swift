//
//  BookNavigator.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxCocoa

protocol BookNavigator {
    func to(book: BookInfo)
    func loaded(book: Book) -> [UIViewController]
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

    func loaded(book: Book) -> [UIViewController] {
        let contentController: ContentViewController = storyboard.instantiateViewController()
        contentController.viewModel = ContentViewModel(book: book,
                                                       booksUseCase: self.services.booksUseCase(),
                                                       navigator: self)

        let notesController: AnnotationViewController = storyboard.instantiateViewController()
        notesController.viewModel = AnnotationViewModel(book: book,
                                                        annotationsUseCase: services.annotationsUseCase(),
                                                        navigator: self)

        let bookmarksController: BookmarksViewController = storyboard.instantiateViewController()
        bookmarksController.viewModel = BookmarksViewModel(book: book,
                                                           useCase: services.bookmarkUseCase(),
                                                           navigator: self)

        contentController.tabBarItem = UITabBarItem(title: "Outline", image: nil, tag: 0)
        notesController.tabBarItem = UITabBarItem(title: "Notes", image: nil, tag: 0)
        bookmarksController.tabBarItem = UITabBarItem(title: "Bookmarks", image: nil, tag: 0)

        return [contentController, notesController, bookmarksController]
    }

    func to(book info: BookInfo) {
        let tabController = BookViewController()
        tabController.viewModel = BookViewModel(booksUseCase: self.services.booksUseCase(),
                                                navigator: self,
                                                bookInfo: info)
        rootController.pushViewController(tabController, animated: true)
    }

    func to(chapterId: Int, of book: Book) {
        let navigator = DefaultChaptersNavigator(services: services,
                                                 storyboard: storyboard,
                                                 controller: rootController)
        navigator.to(chapterId: chapterId, of: book)
    }

    func toEdit(annotation: Annotationable) -> Driver<String> {
        let navigator = DefaultEditAnnotationNavigator(services: services, controller: rootController)
        return navigator.toEditNote(annotation: annotation)
    }
}
