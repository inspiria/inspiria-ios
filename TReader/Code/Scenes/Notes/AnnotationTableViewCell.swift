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

    func set(model: Annotation) {
        dateLabel.text = dateString(from: model.date)
        quoteLabel.text = model.quote
        userTextLabel.text = model.text
    }

    func dateString(from date: Date) -> String {
        let calendar = Calendar.autoupdatingCurrent
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true

        if calendar.isDateInToday(date) {
            formatter.timeStyle = .short
            formatter.dateStyle = .none
        } else if calendar.isDateInYesterday(date) {
            formatter.timeStyle = .short
            formatter.dateStyle = .medium
        } else {
            formatter.timeStyle = .none
            formatter.dateStyle = .medium
        }

        return formatter.string(from: date)
    }
}
