//
//  WebViewConfiguration.swift
//  TReader
//
//  Created by tadas on 2020-04-05.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import WebKit

class WebViewConfiguration: WKWebViewConfiguration {
    override init() {
        super.init()

        let cssString = ""
        let source = "var style = document.createElement('style'); style.innerHTML = '\(cssString)'; document.head.appendChild(style); "

        let userScript = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)

        self.userContentController = userContentController
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
