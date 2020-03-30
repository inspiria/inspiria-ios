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
        return CGRect(x: 0, y: 0, width: 30, height: 30)
    }

    func textView(_ textView: TextView, imageFor attachment: NSTextAttachment, with size: CGSize) -> UIImage? {
        guard let att = attachment as? HTMLAttachment else {
            return #imageLiteral(resourceName: "DownloadError")
        }
        print(att.rawHTML)
        return #imageLiteral(resourceName: "DownloadError")
    }
}

class TRTextViewAttachmentProvider: TextViewAttachmentDelegate {
    private let bookId: Int
    private let fileService: BookFilesService

    init(bookId: Int) {
        self.bookId = bookId
        self.fileService = DefaultBookFilesService(manager: FileManager.default)
    }

    func textView(_ textView: TextView,
                  attachment: NSTextAttachment,
                  imageAt url: URL,
                  onSuccess success: @escaping (UIImage) -> Void,
                  onFailure failure: @escaping () -> Void) {
        failure()
    }

    func textView(_ textView: TextView, urlFor imageAttachment: ImageAttachment) -> URL? {
        print("urlFor: \(imageAttachment)")
        return nil
    }

    func textView(_ textView: TextView, placeholderFor attachment: NSTextAttachment) -> UIImage {
        guard let imageAttachment = attachment as? ImageAttachment else {
            return #imageLiteral(resourceName: "EmptyImage")
        }
        guard let url = imageAttachment.url?.lastPathComponent else {
            print("not found: \(imageAttachment.url)")
            return #imageLiteral(resourceName: "EmptyImage")
        }
        let imagePath = fileService.getBookUrl(id: bookId).appendingPathComponent(url)
        guard let data = try? Data(contentsOf: imagePath), let image = UIImage(data: data) else {
            print("no data loaded: \(imagePath)")
            return #imageLiteral(resourceName: "EmptyImage")
        }

        return image
    }

    func textView(_ textView: TextView, deletedAttachment attachment: MediaAttachment) {
        print("delete: \(attachment)")
    }

    func textView(_ textView: TextView, selected attachment: NSTextAttachment, atPosition position: CGPoint) {
        print("selected: \(attachment)")
    }

    func textView(_ textView: TextView, deselected attachment: NSTextAttachment, atPosition position: CGPoint) {
        print("deselected: \(attachment)")
    }
}
