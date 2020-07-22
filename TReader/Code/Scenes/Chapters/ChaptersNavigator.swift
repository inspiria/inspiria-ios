//
//  ChaptersNavigator.swift
//  TReader
//
//  Created by tadas on 2020-04-03.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

protocol ChaptersNavigator {
    func back()
    func toBook()
    func toSearch()
    func to(chapterId: Int, of book: Book)
    func toEdit(annotation: Annotation)
    func toCreate(text: String)
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

    func toSearch() {
        let vc = UIViewController()
        vc.view.backgroundColor = .systemOrange
        rootController.present(vc, animated: true, completion: nil)
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
                                                    navigator: self,
                                                    booksUseCase: services.booksUseCase())
        return viewController
    }

    func toEdit(annotation: Annotation) {
        let navigator = DefaultEditNoteNavigator(services: services, controller: rootController)
        navigator.toEditNote()
    }

    func toCreate(text: String) {
        let navigator = DefaultEditNoteNavigator(services: services, controller: rootController)
        navigator.toEditNote()
    }
}
