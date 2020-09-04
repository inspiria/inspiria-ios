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

        let controller = WKUserContentController()
        let scripts = ["error", "anchoring", "anchoring_standalone", "higlight", "select"]
        scripts
            .compactMap { WebViewConfiguration.script(with: $0) }
            .forEach { controller.addUserScript($0) }

        self.userContentController = controller
        self.preferences.javaScriptEnabled = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    static func script(with name: String) -> WKUserScript? {
        guard let path = Bundle.main.path(forResource: name, ofType: "js") else { return nil }
        guard let js = try? String(contentsOfFile: path) else { return nil }
        return WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
    }
}
