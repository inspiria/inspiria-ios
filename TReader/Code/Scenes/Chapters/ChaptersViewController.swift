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
    var viewModel: ChaptersViewModel!

    private var menuBar: UINavigationBar!
    private var backButton: UIBarButtonItem!
    private var menuButton: UIBarButtonItem!
    private var contentButton: UIBarButtonItem!
    private var textSizeButton: UIBarButtonItem!
    private var searchButton: UIBarButtonItem!
    private var bookmarkButton: UIBarButtonItem!
    private let currentChapter = BehaviorRelay(value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    private func configureView() {
        dataSource = self
        delegate = self

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
        let input = ChaptersViewModel.Input(toContent: contentButton.rx.tap.asDriver(),
                                            search: searchButton.rx.tap.asDriver(),
                                            addBookmark: bookmarkButton.rx.tap.asDriver(),
                                            chapter: currentChapter.asDriver())
        let output = self.viewModel.transform(input: input)
        currentChapter.accept(output.initChapter)

        backButton
            .rx.tap
            .subscribe(onNext: { [unowned self] in self.navigationController?.popViewController(animated: true) })
            .disposed(by: rx.disposeBag)

        output.hasBookmark
            .map { $0 ? #imageLiteral(resourceName: "ButtonBookmarkSelected") : #imageLiteral(resourceName: "ButtonBookmark") }
            .drive(onNext: { [unowned self] in self.bookmarkButton.image = $0 })
            .disposed(by: rx.disposeBag)

        output.drivers.forEach {
            $0.drive().disposed(by: rx.disposeBag)
        }
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
        return viewModel.previousChapterViewController(viewController.viewModel.chapter.id)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? ChapterViewController else { return nil }
        return viewModel.nextChapterViewController(viewController.viewModel.chapter.id)
    }
}

extension ChaptersViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard finished, completed, let viewController = viewControllers?.first as? ChapterViewController else { return }
        currentChapter.accept(viewController.viewModel.chapter.id)
    }
}
