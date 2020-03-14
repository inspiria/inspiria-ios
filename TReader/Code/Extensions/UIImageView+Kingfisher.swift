//
//  UIImageView+Kingfisher.swift
//  TReader
//
//  Created by tadas on 2020-03-06.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setBookCover(url: String) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: self.frame.size) |> RoundCornerImageProcessor(cornerRadius: 3)
        let scale = UIScreen.main.scale
        kf.cancelDownloadTask()
        kf.indicatorType = .activity
        kf.setImage(with: url,
                    options: [.processor(processor),
                              .scaleFactor(scale),
                              .transition(.fade(1)),
                              .cacheOriginalImage,
                              .onFailureImage(#imageLiteral(resourceName: "BookCover"))
        ])
    }
    
    func setImage(url: String) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: self.frame.size)
        let scale = UIScreen.main.scale
        kf.cancelDownloadTask()
        kf.indicatorType = .activity
        kf.setImage(with: url,
                    options: [.processor(processor),
                              .scaleFactor(scale),
                              .transition(.fade(1)),
                              .cacheOriginalImage
        ])
    }
}
