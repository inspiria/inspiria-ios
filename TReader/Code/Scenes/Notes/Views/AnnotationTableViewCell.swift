//
//  AnnotationTableViewCell.swift
//  TReader
//
//  Created by tadas on 2020-05-27.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class AnnotationTableViewCell: UITableViewCell {

    @IBOutlet var containerView: UIView!

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var chapterLabel: UILabel!
    @IBOutlet var pageLabel: UILabel!
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var userTextLabel: UILabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        let cornerRadius: CGFloat = 3.0
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        containerView.layer.shadowRadius = 2
        containerView.layer.cornerRadius = cornerRadius
    }

    func set(model: Annotation, highlight: String? = nil) {
        dateLabel.text = model.updated.formatedString()

        if let str = highlight, !str.isEmpty {
            quoteLabel.attributedText = model.quote.highlight(text: str)
            userTextLabel.attributedText = model.text.highlight(text: str)
        } else {
            quoteLabel.text = model.quote
            userTextLabel.text = model.text
        }
    }
}

extension String {
    func highlight(text: String) -> NSAttributedString? {
        guard let regex = try? NSRegularExpression(pattern: text, options: .caseInsensitive) else { return nil }
        let string = NSMutableAttributedString(string: self)
        let range = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: range)

        matches.forEach {
            string.addAttribute(NSAttributedString.Key.foregroundColor,
                                          value: ColorStyle.orange.color,
                                          range: $0.range)
        }
        return string
    }
}
