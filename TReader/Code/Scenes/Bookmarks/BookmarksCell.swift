//
//  BookmarksCell.swift
//  TReader
//
//  Created by tadas on 2020-05-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class BookmarksCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var pageLabel: UILabel!

    func set(model: Bookmark) {
        titleLabel.text = model.title
        dateLabel.text = model.date.formatedString()
        pageLabel.text = String(model.page)
    }
}
