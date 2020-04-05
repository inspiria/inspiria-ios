//
//  TRTextView.swift
//  TReader
//
//  Created by tadas on 2020-03-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import Aztec

import RxSwift
import RxCocoa

class TRTextView: Aztec.TextView {
    init() {
        super.init(
            defaultFont: TextStyle.Book.bodyText.font,
            defaultParagraphStyle: ParagraphStyle.default,
            defaultMissingImage: #imageLiteral(resourceName: "DownloadError"))

        registerAttachmentImageProvider(TRImageProvider())
        UIMenuController.shared.menuItems = []
        allowsEditingTextAttributes = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
