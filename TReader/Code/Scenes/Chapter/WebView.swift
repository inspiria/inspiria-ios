//
//  WebView.swift
//  TReader
//
//  Created by tadas on 2020-07-21.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import WebKit

class WebView: WKWebView {

    private let defaultColor = "#FEFFB8"

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setDefaultMenu()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(self.annotate): return true
        case #selector(self.highlight): return true
        case #selector(self.copy(_:)): return (UIMenuController.shared.menuItems?.count ?? 0 > 2 ? false : true)
        default: return false
        }
    }

    private func setDefaultMenu() {
        let annotate = UIMenuItem(title: "Annotate", action: #selector(self.annotate))
        let highlight = UIMenuItem(title: "Highlight", action: #selector(self.highlight))
        UIMenuController.shared.menuItems = [annotate, highlight]
    }

    @objc private func annotate() {
        let js = "annotate(\"\(defaultColor)\");"
        evaluateJavaScript(js) { (obj, err) in
            if let err = err { print(err) }
            if let obj = obj { print(obj) }
        }
        UIMenuController.shared.hideMenu()
    }

    @objc private func highlight() {
        let js = "highlight(\"\(defaultColor)\");"
        evaluateJavaScript(js) { (obj, err) in
            if let err = err { print(err) }
            if let obj = obj { print(obj) }
        }
        UIMenuController.shared.hideMenu()
    }
}
