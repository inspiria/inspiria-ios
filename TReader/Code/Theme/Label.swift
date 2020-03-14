//
//  Label.swift
//  TReader
//
//  Created by tadas on 2020-03-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class Label: UILabel {
    var textStyle: TextStylable? {
        didSet {
            font = textStyle?.font
        }
    }
    
    override var text: String? {
        set {
            guard let textStyle = textStyle else {
                return super.text = newValue
            }
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.maximumLineHeight = textStyle.lineHeight
            paragraphStyle.minimumLineHeight = textStyle.lineHeight
            paragraphStyle.lineBreakMode = .byTruncatingTail
            
            let attributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle,
                              NSAttributedString.Key.font: textStyle.font]
            
            self.attributedText = newValue.flatMap { NSAttributedString(string: $0, attributes: attributes)}
        }
        get {
            return super.text
        }
    }
}
