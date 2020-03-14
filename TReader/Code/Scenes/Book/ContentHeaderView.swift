//
//  ContentHeaderView.swift
//  TReader
//
//  Created by tadas on 2020-03-06.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class ContentHeaderView: UIView {
    private let coverImage: UIImageView
    private let titleLabel: UILabel
    private let authorLabel: UILabel

    init(title: String, author: String, coverUrl: String) {
        let width = UIScreen.main.bounds.width - 48
        let spacing: CGFloat = 12
        let title = title + ". Some extra characters to test layout of the book name. And some mote text!"

        coverImage = UIImageView(frame: CGRect(x: 0, y: spacing, width: 64, height: 90))
        titleLabel = UILabel(frame: CGRect(x: 80, y: spacing, width: width - 80, height: 90))
        authorLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 21))

        titleLabel.text = title
        titleLabel.font = TextStyle.Book.h1.font
        titleLabel.textColor = ColorStyle.textDark.color
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()

        authorLabel.frame.origin.y = max(coverImage.frame.maxY, titleLabel.frame.maxY) + spacing
        authorLabel.text = author
        authorLabel.font = TextStyle.Book.bodyText.font
        authorLabel.textColor = ColorStyle.orange.color
        authorLabel.numberOfLines = 0

        coverImage.setBookCover(url: coverUrl)

        super.init(frame: CGRect.zero)

        let height = authorLabel.frame.maxY + spacing

        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        self.widthAnchor.constraint(equalToConstant: width).isActive = true

        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(coverImage)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
