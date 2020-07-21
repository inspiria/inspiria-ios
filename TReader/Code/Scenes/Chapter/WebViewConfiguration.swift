//
//  WebViewConfiguration.swift
//  TReader
//
//  Created by tadas on 2020-04-05.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import WebKit

class WebViewConfiguration: WKWebViewConfiguration, WKScriptMessageHandler {
    override init() {
        super.init()

        let controller = WKUserContentController()

        if let js = Self.script(with: "error") {
            let userScript = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: true)
            controller.addUserScript(userScript)

            controller.add(self, name: "error")
            controller.add(self, name: "log")
        }
        if let js = Self.script(with: "highlight") {
            let userScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
            controller.addUserScript(userScript)
        }

        self.userContentController = controller
        self.preferences.javaScriptEnabled = true
    }

    static func script(with name: String) -> String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "js") else { return nil }
        return try? String(contentsOfFile: path)
    }

    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        switch message.name {
        case "error":
            print(message.body)
        default:
            print(message.name)
            print(message.body)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
