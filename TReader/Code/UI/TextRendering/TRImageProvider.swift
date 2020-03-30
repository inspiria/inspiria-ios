//
//  TRImageProvider.swift
//  TReader
//
//  Created by tadas on 2020-03-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import Aztec

class TRImageProvider: TextViewAttachmentImageProvider {
    func textView(_ textView: TextView, shouldRender attachment: NSTextAttachment) -> Bool {
        return true
    }

    func textView(_ textView: TextView, boundsFor attachment: NSTextAttachment, with lineFragment: CGRect) -> CGRect {
        guard (attachment as? ImageAttachment) != nil else {
            return CGRect.zero
        }

        return CGRect(x: 0, y: 0, width: lineFragment.width, height: 200)
    }

    func textView(_ textView: TextView, imageFor attachment: NSTextAttachment, with size: CGSize) -> UIImage? {
        guard (attachment as? ImageAttachment) != nil else {
            return nil
        }

        return #imageLiteral(resourceName: "Library")
    }
}
