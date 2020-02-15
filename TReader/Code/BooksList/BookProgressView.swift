//
//  BookProgressView.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import UIKit

class BookProgressView: UIView {

    private let bgColor = ColorStyle.bkgrndWhite.color.withAlphaComponent(0.75)

    enum State {
        case waiting
        case downloading
        case downloaded
        case error
    }

    var state: State = .waiting {
        didSet {
            setNeedsDisplay()
        }
    }
    var progress: Float = 0 {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        switch state {
        case .waiting:
            bgColor.set()
            UIGraphicsGetCurrentContext()?.fill(rect)
        case .downloading:
            drawProgressCircleInRect(bounds)
        case .downloaded:
            UIColor.clear.set()
            UIGraphicsGetCurrentContext()?.fill(rect)
        case .error:
            bgColor.set()
            UIGraphicsGetCurrentContext()?.fill(rect)
            let backgroundImage = #imageLiteral(resourceName: "DownloadError")
            backgroundImage.draw(at: CGPoint(x: (bounds.size.width - backgroundImage.size.width) / 2, y: (bounds.size.height - backgroundImage.size.height) / 2))

        }
    }

    func drawProgressCircleInRect(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()

        bgColor.set()
        context?.fill(rect)

        let marginRatio: CGFloat = 0.9
        let x = rect.size.width / 2.0
        let y = rect.size.height / 2.0
        var progress = CGFloat(self.progress)
        if progress == 0 {
            progress = 0.02
        }
        let floatMPI = CGFloat.pi
        context?.move(to: CGPoint(x: x, y: y))
        context?.addArc(center: CGPoint(x: x, y: y),
                        radius: (rect.size.width - 4.0) / 2.0 * marginRatio,
                        startAngle: -(floatMPI / 2.0),
                        endAngle: (progress * 2.0 * floatMPI) - floatMPI / 2.0,
                        clockwise: false)
        context?.closePath()
        context?.setBlendMode(.clear)
        context?.fillPath()

    }

}
