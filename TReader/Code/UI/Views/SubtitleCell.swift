//
//  SubtitleCell.swift
//  TReader
//
//  Created by tadas on 2020-05-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class SubtitleCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var sufixLabel: UILabel!

    func set(model: Bookmark) {
        titleLabel.text = model.title
        subtitleLabel.text = model.date.formatedString()
        sufixLabel.text = String(model.page)
    }
}
