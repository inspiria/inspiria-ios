//
//  ChapterViewController.swift
//  TReader
//
//  Created by tadas on 2020-03-05.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

class ChapterViewController: UIViewController {
    var viewModel: ChapterViewModel!

    // swiftlint:disable force_cast
    private var webView: WKWebView { view as! WKWebView }
    // swiftlint:enable force_cast

    private var openChapterSubject = PublishSubject<(Int, Int)>()

    override func loadView() {
        let webConfiguration = WebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        let openChapter = openChapterSubject.asDriverOnErrorJustComplete()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let input = ChapterViewModel.Input(trigger: viewWillAppear, openChapter: openChapter)
        let output = viewModel.transform(input: input)

        output.chapter
            .drive(onNext: { [unowned self] chapter in
                self.parent?.navigationItem.title = chapter.title

                let storage = DefaultBookFilesService(manager: FileManager.default)
                let file = storage.getChapterUrl(id: chapter.bookId, chapterFile: chapter.fileName)
                let book = storage.getBookUrl(id: chapter.bookId)
                print(file)
                self.webView.loadFileURL(file, allowingReadAccessTo: book)
            })
            .disposed(by: rx.disposeBag)

        output.openChapter
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

extension ChapterViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated,
            let url = navigationAction.request.url {
            if let deepLink = DeepLink(url: url),
                case DeepLink.chapter(let bookId, let chapterId) = deepLink {
                openChapterSubject.onNext((bookId, chapterId))
            } else if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
