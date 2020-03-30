//
//  ContentHeaderView.swift
//  TReader
//
//  Created by tadas on 2020-03-06.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class ContentHeaderView: UIView {
    private let imageView: UIImageView
    private let titleLabel: TRLabel
    private let authorLabel: TRLabel

    init(title: String, author: String, coverUrl: String) {
        let spacing: CGFloat = 12
        let width = UIScreen.main.bounds.width - spacing * 2

        imageView = UIImageView(frame: CGRect(x: spacing, y: spacing, width: 64, height: 90))
        imageView.setBookCover(url: coverUrl)

        titleLabel = TRLabel(frame: CGRect(x: imageView.frame.maxX + spacing, y: spacing,
                                         width: width - imageView.frame.maxX - spacing, height: 0))
        titleLabel.textStyle = TextStyle.Book.h1
        titleLabel.text = title
        titleLabel.textColor = ColorStyle.textDark.color
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()

        let y = max(imageView.frame.maxY, titleLabel.frame.maxY) + spacing
        authorLabel = TRLabel(frame: CGRect(x: spacing, y: y, width: width - spacing*2, height: 0))
        authorLabel.textStyle = TextStyle.Book.bodyText
        authorLabel.text = author
        authorLabel.textColor = ColorStyle.orange.color
        authorLabel.numberOfLines = 0
        authorLabel.sizeToFit()

        super.init(frame: CGRect.zero)

        let height = authorLabel.frame.maxY + spacing
        self.heightAnchor.constraint(equalToConstant: height).isActive = true

        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
