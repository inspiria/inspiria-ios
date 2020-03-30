//
//  AuthorSectionView.swift
//  TReader
//
//  Created by tadas on 2020-03-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class AuthorSectionView: UIView {
    private let imageView: UIImageView
    private let headerLabel: TRLabel
    private let textView: TRTextView

    init(name: String, text: String, photoUrl: String?) {

        let spacing: CGFloat = 12
        let width = UIScreen.main.bounds.width - spacing * 2

        headerLabel = TRLabel(frame: CGRect(x: spacing, y: spacing, width: width - spacing*2, height: 0))
        headerLabel.textStyle = TextStyle.Book.h3
        headerLabel.text = name
        headerLabel.textColor = ColorStyle.textDark.color
        headerLabel.numberOfLines = 0
        headerLabel.sizeToFit()

        if let photoUrl = photoUrl {
            imageView = UIImageView(frame: CGRect(x: spacing, y: headerLabel.frame.maxY + spacing, width: 160, height: 160))
            imageView.setImage(url: photoUrl)
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView = UIImageView(frame: CGRect(x: spacing, y: headerLabel.frame.maxY + spacing, width: 0, height: 0))
        }

        textView = TRTextView()
        textView.frame = CGRect(x: spacing, y: imageView.frame.maxY + spacing, width: width - spacing*2, height: 0)
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.setHTML(text)
        textView.sizeToFit()

        super.init(frame: CGRect.zero)

        let height = textView.frame.maxY + spacing
        self.heightAnchor.constraint(equalToConstant: height).isActive = true

        addSubview(headerLabel)
        addSubview(imageView)
        addSubview(textView)

        backgroundColor = ColorStyle.iconsLight.color
        layer.shadowOpacity = 0.25
        layer.cornerRadius = 3
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowColor = UIColor.black.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
