//
//  Label.swift
//  TReader
//
//  Created by tadas on 2020-03-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class TRLabel: UILabel {
    var textStyle: TextStylable? {
        didSet {
            font = textStyle?.font
        }
    }

    var headIndent: CGFloat = 0

    override var text: String? {
        set {
            guard let textStyle = textStyle else {
                return super.text = newValue
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = textStyle.lineHeight
            paragraphStyle.minimumLineHeight = textStyle.lineHeight
            paragraphStyle.lineBreakMode = .byTruncatingTail
            paragraphStyle.firstLineHeadIndent = headIndent
            paragraphStyle.headIndent = headIndent
            paragraphStyle.tailIndent = -headIndent

            let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                              NSAttributedString.Key.font: textStyle.font]

            self.attributedText = newValue.flatMap { NSAttributedString(string: $0, attributes: attributes)}
        }
        get {
            return super.text
        }
    }

    func set(html: String) {
        guard let textStyle = textStyle else {
            return super.attributedText = html.htmlAttributedString
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.maximumLineHeight = textStyle.lineHeight
        paragraphStyle.minimumLineHeight = textStyle.lineHeight
        paragraphStyle.lineBreakMode = .byTruncatingTail

        let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                          NSAttributedString.Key.font: textStyle.font]
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey.defaultAttributes: attributes,
            NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]

        let string = html.data(using: .unicode) ?? Data()
        self.attributedText = try? NSAttributedString(data: string, options: options, documentAttributes: nil)
    }
}

extension String {
    var htmlAttributedString: NSAttributedString? {
        let string = self.data(using: .unicode) ?? Data()
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        return try? NSAttributedString(data: string, options: options, documentAttributes: nil)
    }
}
