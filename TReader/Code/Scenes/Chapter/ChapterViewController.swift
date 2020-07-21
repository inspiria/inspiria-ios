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
import MenuItemKit

class WebView: WKWebView {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.copy(_:)) {
            return true
        }
        return false
    }
}

class ChapterViewController: UIViewController {
    var viewModel: ChapterViewModel!

    // swiftlint:disable force_cast
    private var webView: WKWebView { view as! WKWebView }
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
        setDefaultMenu()
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

    func setDefaultMenu() {
//        UIMenuController.shared.setDefaultMenu { highlight in
//            if highlight {
//                self.highlight()
//            } else {
//                self.note()
//            }
//        }

        let highlight = UIMenuItem(title: "Highlight", action: #selector(self.highlight))
        let note = UIMenuItem(title: "Note", action: #selector(self.note))
        UIMenuController.shared.menuItems = [highlight, note]
    }

    @objc func highlight() {
        let js = "highlight(\"pink\");"
        webView.evaluateJavaScript(js) { (obj, err) in
            if let err = err { print(err) }
            if let obj = obj { print(obj) }
        }
        UIMenuController.shared.hideMenu()
    }

    @objc func note() {
        var rect = UIMenuController.shared.menuFrame
        rect.origin.y = rect.maxY
        UIMenuController.shared.hideMenu()
        
        UIMenuController.shared.setColorsMenu { [weak self] (color: String) in
            UIMenuController.shared.hideMenu()
            let js = "highlight(\"\(color)\");"
            self?.setDefaultMenu()
            self?.webView.evaluateJavaScript(js) { (obj, err) in
                if let err = err { print(err) }
                if let obj = obj { print(obj) }
            }
        }
        UIMenuController.shared.showMenu(from: webView, rect: rect)
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

extension UIMenuController {
    func setDefaultMenu(action: @escaping (Bool) -> Void) {
        let highlight = UIMenuItem(title: "Highlight") { _ in action(true) }
        let note = UIMenuItem(title: "Note") { _ in action(false) }
        UIMenuController.shared.menuItems = [highlight, note]
    }

    func setColorsMenu(action: @escaping (String) -> Void) {
        let blue = UIMenuItem(title: "Blue", image: #imageLiteral(resourceName: "EllipseBlue")) { _ in action("blue") }
        let green = UIMenuItem(title: "Green", image: #imageLiteral(resourceName: "EllipseGreen")) { _ in action("green") }
        let purple = UIMenuItem(title: "Purple", image: #imageLiteral(resourceName: "EllipsePurple")) { _ in action("purple") }
        let red = UIMenuItem(title: "Red", image: #imageLiteral(resourceName: "EllipseRed")) { _ in action("red") }
        let yellow = UIMenuItem(title: "Yellow", image: #imageLiteral(resourceName: "EllipseYellow")) { _ in action("yellow") }
        UIMenuController.shared.menuItems = [blue, green, purple, red, yellow]
    }
}
