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

class ChaptersViewController: UIPageViewController {
    var navigator: ChaptersNavigator!
    var book: Book!
    var storage: BookmarkStorage!

    private var menuBar: UINavigationBar!
    private var backButton: UIBarButtonItem!
    private var menuButton: UIBarButtonItem!
    private var contentButton: UIBarButtonItem!
    private var textSizeButton: UIBarButtonItem!
    private var searchButton: UIBarButtonItem!
    private var bookmarkButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    private func configureView() {
        dataSource = self
        view.backgroundColor = .white

        menuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Dots"), style: .done, target: nil, action: nil)
        backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Back"), style: .done, target: nil, action: nil)
        contentButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ButtonMenu"), style: .done, target: nil, action: nil)
        textSizeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ButtonTextSize"), style: .done, target: nil, action: nil)
        searchButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ButtonSearch"), style: .done, target: nil, action: nil)
        bookmarkButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ButtonBookmark"), style: .done, target: nil, action: nil)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .white

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = ColorStyle.textGray.color
        navigationItem.leftBarButtonItems = [backButton, contentButton]
        navigationItem.rightBarButtonItems = [bookmarkButton, searchButton, textSizeButton]
    }

    private func bindViewModel() {
        backButton
            .rx.tap
            .subscribe(onNext: navigator.toBook)
            .disposed(by: rx.disposeBag)

        contentButton
            .rx.tap
            .subscribe(onNext: navigator.toBook)
            .disposed(by: rx.disposeBag)

        searchButton
            .rx.tap
            .subscribe(onNext: navigator.toSearch)
            .disposed(by: rx.disposeBag)

        bookmarkButton
            .rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.bookmarkButton.image = #imageLiteral(resourceName: "ButtonBookmarkSelected")
            })
            .disposed(by: rx.disposeBag)
    }

    override func willMove(toParent parent: UIViewController?) {
        guard parent == nil else { return }
        navigationController?.navigationBar.standardAppearance = UINavigationBar.appearance().standardAppearance
        navigationController?.navigationBar.tintColor = ColorStyle.bkgrndWhite.color
    }
}

extension ChaptersViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ChapterViewController else { return nil }
        return navigator.previousChapterViewController(chapterId: viewController.viewModel.chapter.id, book: book)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ChapterViewController else { return nil }
        return navigator.nextChapterViewController(chapterId: viewController.viewModel.chapter.id, book: book)
    }
}
