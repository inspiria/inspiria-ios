//
//  ChapterNavigator.swift
//  TReader
//
//  Created by tadas on 2020-03-05.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

protocol ChapterNavigator {
    func to(chapter: Chapter)
}

class DefaultChapterNavigator: ChapterNavigator {
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

    func to(chapter: Chapter) {
        let viewController: ChapterViewController = storyboard.instantiateViewController()
        viewController.viewModel = ChapterViewModel(chapter: chapter, navigator: self)
        rootController.pushViewController(viewController, animated: true)
    }
}
