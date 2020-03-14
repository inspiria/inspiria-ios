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
    private let titleLabel: Label
    private let authorLabel: Label

    init(title: String, author: String, coverUrl: String) {
        let width = UIScreen.main.bounds.width - 48
        let spacing: CGFloat = 12

        coverImage = UIImageView(frame: CGRect(x: 0, y: spacing, width: 64, height: 90))
        titleLabel = Label(frame: CGRect(x: 80, y: spacing, width: width - 80, height: 90))
        authorLabel = Label(frame: CGRect(x: 0, y: 0, width: width, height: 21))

        titleLabel.textStyle = TextStyle.Book.h1
        titleLabel.text = title
        titleLabel.textColor = ColorStyle.textDark.color
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()

        
        authorLabel.frame.origin.y = max(coverImage.frame.maxY, titleLabel.frame.maxY) + spacing
        authorLabel.textStyle = TextStyle.Book.bodyText
        authorLabel.text = author
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
