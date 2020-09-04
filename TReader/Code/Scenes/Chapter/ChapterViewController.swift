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
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let input = ChapterViewModel.Input(trigger: viewWillAppear, openChapter: openChapter)
        let output = viewModel.transform(input: input)

        output.chapter
            .drive(onNext: { [unowned self] chapter in
                let storage = DefaultBookFilesService(manager: FileManager.default)
                let file = storage.getChapterUrl(id: chapter.bookId, chapterFile: chapter.fileName)
                let book = storage.getBookUrl(id: chapter.bookId)
                self.webView.loadFileURL(file, allowingReadAccessTo: book)
            })
            .disposed(by: rx.disposeBag)

        output.openChapter
            .drive()
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
        webView.configuration.userContentController.add(self, name: "annotate")
        webView.configuration.userContentController.add(self, name: "highlight")
        webView.configuration.userContentController.add(self, name: "select")
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "error":
            print("js error: \(message.body)")
        case "annotate":
            guard let str = message.body as? String else { return }
            guard let annotation = try? JSAnnotation(json: str) else { return }
            webView.add(annontation: annotation)
            viewModel.add(annotation: annotation)
        case "highlight":
            guard let str = message.body as? String else { return }
            guard let annotation = try? JSAnnotation(json: str) else { return }
            webView.add(annontation: annotation)
            viewModel.add(highlight: annotation)
        case "select":
            print("js select: \(message.body)")
            guard let ann = message.body as? String else { return }
            viewModel.edit(annotation: ann)
        default:
            print(message.name)
            print(message.body)
        }
    }
}
