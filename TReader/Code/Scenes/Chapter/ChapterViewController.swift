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
    private var webView: WebView { view as! WebView }
    // swiftlint:enable force_cast

    private var openChapterSubject = PublishSubject<(Int, Int)>()
    private var jsAction = PublishSubject<(JSAction, JSAnnotation)>()

    override func loadView() {
        let webConfiguration = WebViewConfiguration()
        let webView = WebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerJSCallbacks()
        bindViewModel()
    }

    private func bindViewModel() {
        let openChapter = openChapterSubject.asDriverOnErrorJustComplete()
        let annotationAction = jsAction.asDriverOnErrorJustComplete()
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let input = ChapterViewModel.Input(trigger: viewWillAppear, openChapter: openChapter, annotationAction: annotationAction)
        let output = viewModel.transform(input: input)

        output.chapter
            .drive(onNext: { [unowned self] chapter in
                let storage = DefaultBookFilesService(manager: FileManager.default)
                let file = storage.getChapterUrl(id: chapter.bookId, chapterFile: chapter.fileName)
                let book = storage.getBookUrl(id: chapter.bookId)
                self.webView.loadFileURL(file, allowingReadAccessTo: book)
            })
            .disposed(by: rx.disposeBag)

        output.drivers.forEach {
            $0.drive().disposed(by: rx.disposeBag)
        }

        output.error
            .drive(rx.errorBinding)
            .disposed(by: rx.disposeBag)

        output.activity
            .drive(rx.isRefreshingBinding)
            .disposed(by: rx.disposeBag)

        output.annotations
            .map { $0.compactMap { $0.jsAnnotation() } }
            .drive(onNext: { [unowned self] ann in
                self.webView.add(annontations: ann)
            })
            .disposed(by: rx.disposeBag)
    }
}

extension ChapterViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        print(message)
        completionHandler()
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

extension ChapterViewController: WKScriptMessageHandler {
    func registerJSCallbacks() {
        webView.configuration.userContentController.add(self, name: "error")
        webView.configuration.userContentController.add(self, name: JSAction.annotate.rawValue)
        webView.configuration.userContentController.add(self, name: JSAction.highlight.rawValue)
        webView.configuration.userContentController.add(self, name: JSAction.select.rawValue)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard  let action = JSAction(rawValue: message.name),
               let str = message.body as? String,
               let annotation = try? JSAnnotation(json: str) else { return print(message) }
        jsAction.onNext((action, annotation))
    }
}
