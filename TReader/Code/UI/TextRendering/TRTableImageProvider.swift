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
        guard let attachment = attachment as? HTMLAttachment, let text = attachment.rawHTML.htmlAttributedString else {
                return CGRect.zero
        }

//        let size = CGSize(width: lineFragment.width, height: 10000)
//        let rect = text.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
//        return rect
        return CGRect(x: 0, y: 0, width: lineFragment.width, height: 600)
    }

    func textView(_ textView: TextView, imageFor attachment: NSTextAttachment, with size: CGSize) -> UIImage? {
        guard let attachment = attachment as? HTMLAttachment, let text = attachment.rawHTML.htmlAttributedString else {
            return #imageLiteral(resourceName: "DownloadError")
        }
        
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        text.draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysOriginal)
        UIGraphicsEndImageContext()
        return image
    }
}
