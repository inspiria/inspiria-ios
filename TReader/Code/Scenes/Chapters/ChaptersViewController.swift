//
//  ChaptersViewController.swift
//  TReader
//
//  Created by tadas on 2020-04-03.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChaptersViewController: UIPageViewController, UIPageViewControllerDataSource {
    var navigator: ChaptersNavigator!
    var book: Book!

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        view.backgroundColor = .white
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ChapterViewController else { return nil }
        return navigator.previousChapterViewController(chapterId: viewController.viewModel.chapter.id, book: book)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ChapterViewController else { return nil }
        return navigator.nextChapterViewController(chapterId: viewController.viewModel.chapter.id, book: book)
    }
    
}
