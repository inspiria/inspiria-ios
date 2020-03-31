//
//  TRTableImageProvider.swift
//  TReader
//
//  Created by tadas on 2020-03-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import Aztec

class TRTableImageProvider: TextViewAttachmentImageProvider {
    func textView(_ textView: TextView, shouldRender attachment: NSTextAttachment) -> Bool {
        guard let attachment = attachment as? HTMLAttachment else {
            return false
        }

        switch attachment.rootTagName {
        case Element.table.rawValue:
            return true
        default:
            return false
        }
    }

    func textView(_ textView: TextView, boundsFor attachment: NSTextAttachment, with lineFragment: CGRect) -> CGRect {
        guard let attachment = attachment as? HTMLAttachment,
            let text = attachment.rawHTML.htmlAttributedString else {
                return CGRect.zero
        }

        return text.boundingRect(with: CGSize(width: UIScreen.main.bounds.width - 48,
                                              height: CGFloat.greatestFiniteMagnitude),
                                 options: [],
                                 context: nil)
    }

    func textView(_ textView: TextView, imageFor attachment: NSTextAttachment, with size: CGSize) -> UIImage? {
        guard let attachment = attachment as? HTMLAttachment else {
            return #imageLiteral(resourceName: "DownloadError")
        }
        let rect = self.textView(textView, boundsFor: attachment, with: CGRect.zero)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let text = attachment.rawHTML.htmlAttributedString
        text?.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
        UIGraphicsEndImageContext()
        return image
    }
}
