//
//  WebView.swift
//  TReader
//
//  Created by tadas on 2020-07-21.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import WebKit
import MenuItemKit

private struct ColorModel {
    let title: String
    let color: String
    let img: UIImage
}

class WebView: WKWebView {

    private lazy var defaultColor = colors[0]
    private let colors = [ColorModel(title: "Yellow", color: "#FFFACD", img: #imageLiteral(resourceName: "EllipseYellow")),
                          ColorModel(title: "Green", color: "#E3FFCD", img: #imageLiteral(resourceName: "EllipseGreen")),
                          ColorModel(title: "Blue", color: "#CEF0FF", img: #imageLiteral(resourceName: "EllipseBlue")),
                          ColorModel(title: "Red", color: "#FFE1EC", img: #imageLiteral(resourceName: "EllipseRed")),
                          ColorModel(title: "Purple", color: "#CDD2FF", img: #imageLiteral(resourceName: "EllipsePurple"))]

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        setDefaultMenu()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(self.note): return true
        case #selector(self.highlight): return true
        case #selector(self.copy(_:)): return (UIMenuController.shared.menuItems?.count ?? 0 > 2 ? false : true)
        default: return false
        }
    }

    private func setDefaultMenu() {
        let highlight = UIMenuItem(title: "Highlight", action: #selector(self.highlight))
        let note = UIMenuItem(title: "Note", action: #selector(self.note))
        UIMenuController.shared.menuItems = [highlight, note]
    }

    @objc private func note() {
        let js = javaScript(defaultColor)
        evaluateJavaScript(js) { (obj, err) in
            if let err = err { print(err) }
            if let obj = obj { print(obj) }
        }
        UIMenuController.shared.hideMenu()
    }

    @objc private func highlight() {
        var rect = UIMenuController.shared.menuFrame
        rect.origin.y = rect.maxY
        UIMenuController.shared.hideMenu()

        let action = { [weak self] (model: ColorModel) in
            guard let `self` = self else { return }
            UIMenuController.shared.hideMenu()
            let js = self.javaScript(model)
            self.defaultColor = model
            self.setDefaultMenu()
            self.evaluateJavaScript(js) { (obj, err) in
                if let err = err { print(err) }
                if let obj = obj { print(obj) }
            }
        }
        UIMenuController.shared.menuItems = colors.map { model in UIMenuItem(title: model.title, image: model.img) { _ in action(model) } }
        UIMenuController.shared.showMenu(from: self, rect: rect)
    }

    private func javaScript(_ model: ColorModel) -> String {
        return "highlight(\"\(model.color)\");window.getSelection().removeAllRanges();"
    }
}
