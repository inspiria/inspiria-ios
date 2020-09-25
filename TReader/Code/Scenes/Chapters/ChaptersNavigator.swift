//
//  ChaptersNavigator.swift
//  TReader
//
//  Created by tadas on 2020-04-03.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ChaptersNavigator {
    func back()
    func toBook()
    func toSearch(book: Book)
    func to(chapterId: Int, of book: Book)
    func toEdit(annotation: Annotation) -> Driver<String>
    func chapterViewController(chapter: Chapter, book: Book) -> ChapterViewController
}

class DefaultChaptersNavigator: ChaptersNavigator {
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

    func back() {
        rootController.popViewController(animated: true)
    }

    func toBook() {
        rootController.popViewController(animated: true)
    }

    func toSearch(book: Book) {
        let navigator = DefaultSearchBookNavigator(services: services,
                                                   storyboard: storyboard,
                                                   controller: rootController,
                                                   chaptersNavigator: self)
        navigator.toSearch(book: book)
    }

    func to(chapterId: Int, of book: Book) {
        let chapter = book.chapters.filter { $0.id == chapterId }.first!
        let cViewController = chapterViewController(chapter: chapter, book: book)
        let viewController = ChaptersViewController(transitionStyle: .scroll,
                                                    navigationOrientation: .horizontal,
                                                    options: nil)

        viewController.viewModel = ChaptersViewModel(book: book,
                                                     chapterId: chapterId,
                                                     navigator: self,
                                                     booksUseCase: services.booksUseCase(),
                                                     bookmarkUseCase: services.bookmarkUseCase())

        viewController.setViewControllers([cViewController],
                                          direction: .forward,
                                          animated: false,
                                          completion: nil)

        rootController.pushViewController(viewController, animated: true)
    }

    func chapterViewController(chapter: Chapter, book: Book) -> ChapterViewController {
        let viewController: ChapterViewController = storyboard.instantiateViewController()
        viewController.viewModel = ChapterViewModel(chapter: chapter,
                                                    book: book,
                                                    navigator: self,
                                                    booksUseCase: services.booksUseCase(),
                                                    annotationsUseCase: services.annotationsUseCase())
        return viewController
    }

    func toEdit(annotation: Annotation) -> Driver<String> {
        let navigator = DefaultEditAnnotationNavigator(services: services, controller: rootController)
        return navigator.toEditNote(annotation: annotation)
    }
}
