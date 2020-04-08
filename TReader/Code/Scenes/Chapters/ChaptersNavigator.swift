//
//  ChaptersNavigator.swift
//  TReader
//
//  Created by tadas on 2020-04-03.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

protocol ChaptersNavigator {
    func to(chapterId: Int, of book: Book)
    func previousChapterViewController(chapterId: Int, book: Book) -> UIViewController?
    func nextChapterViewController(chapterId: Int, book: Book) -> UIViewController?
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

    func to(chapterId: Int, of book: Book) {
        let chapter = book.chapters.filter { $0.id == chapterId }.first!
        let cViewController = chapterViewController(chapter: chapter, book: book)

        let viewController = ChaptersViewController(transitionStyle: .scroll,
                                                    navigationOrientation: .horizontal,
                                                    options: nil)
        viewController.navigator = self
        viewController.book = book
        viewController.setViewControllers([cViewController], direction: .forward, animated: false, completion: nil)
        rootController.pushViewController(viewController, animated: true)
    }

    func previousChapterViewController(chapterId: Int, book: Book) -> UIViewController? {
        guard let index = book.chapters.firstIndex(where: { $0.id == chapterId }) else { return nil }
        guard index > 0 else { return nil }
        let chapter = book.chapters[index-1]
        let controller = chapterViewController(chapter: chapter, book: book)
        return controller
    }

    func nextChapterViewController(chapterId: Int, book: Book) -> UIViewController? {
        guard let index = book.chapters.firstIndex(where: { $0.id == chapterId }) else { return nil }
        guard index < book.chapters.count - 1 else { return nil }
        let chapter = book.chapters[index+1]
        let controller = chapterViewController(chapter: chapter, book: book)
        return controller
    }

    private func chapterViewController(chapter: Chapter, book: Book) -> ChapterViewController {
        let viewController: ChapterViewController = storyboard.instantiateViewController()
        viewController.viewModel = ChapterViewModel(chapter: chapter,
                                                    navigator: self,
                                                    booksUseCase: services.booksUseCase())
        return viewController
    }
}
