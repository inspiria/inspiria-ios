//
//  TRTextView.swift
//  TReader
//
//  Created by tadas on 2020-03-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import Aztec

class TRTextView: Aztec.TextView {
    init() {
        super.init(
            defaultFont: TextStyle.Book.bodyText.font,
            defaultParagraphStyle: ParagraphStyle.default,
            defaultMissingImage: #imageLiteral(resourceName: "DownloadError"))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
