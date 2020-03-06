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

        coverImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 90))
        titleLabel = UILabel(frame: CGRect(x: 80, y: 0, width: width - 80, height: 90))
        authorLabel = UILabel(frame: CGRect(x: 0, y: 102, width: width, height: 29))

        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = ColorStyle.textDark.color
        titleLabel.numberOfLines = 0

        authorLabel.text = author
        authorLabel.font = .systemFont(ofSize: 14)
        authorLabel.textColor = ColorStyle.orange.color
        authorLabel.numberOfLines = 0

        coverImage.setBookCover(url: coverUrl)

        super.init(frame: CGRect.zero)

        let height = authorLabel.frame.maxY + 10

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
