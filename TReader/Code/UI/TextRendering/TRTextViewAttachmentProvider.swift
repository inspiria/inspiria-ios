//
//  TRTextViewAttachmentProvider.swift
//  TReader
//
//  Created by tadas on 2020-03-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import Aztec

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
        guard let url = imageAttachment.url?.absoluteString else {
            return #imageLiteral(resourceName: "EmptyImage")
        }
        let imagePath = fileService.getBookUrl(id: bookId).appendingPathComponent(url)
        do {
            let data = try Data(contentsOf: imagePath)
            guard let image = UIImage(data: data) else {
                return #imageLiteral(resourceName: "EmptyImage")
            }
            return image
        } catch {
            return #imageLiteral(resourceName: "EmptyImage")
        }
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

