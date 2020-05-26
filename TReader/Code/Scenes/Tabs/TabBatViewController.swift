//
//  TabBatViewController.swift
//  TReader
//
//  Created by tadas on 2020-05-26.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import XLPagerTabStrip

class TabBatViewController: ButtonBarPagerTabStripViewController {
    private let controllers: [UIViewController]

    init(_ controllers: [UIViewController]) {
        self.controllers = controllers
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarLeftContentInset = 27
        settings.style.buttonBarRightContentInset = 27
        settings.style.buttonBarItemTitleColor = ColorStyle.menuDark.color
        settings.style.buttonBarItemFont = TextStyle.Notes.h1.font
        settings.style.buttonBarHeight = 39.0
        settings.style.selectedBarHeight = 0.0
        pagerBehaviour = .common(skipIntermediateViewControllers: true)

        changeCurrentIndex = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, animated: Bool) -> Void in
            oldCell?.imageView.image = nil
            newCell?.imageView.image = #imageLiteral(resourceName: "Tab")
        }
        super.viewDidLoad()
        view.backgroundColor = ColorStyle.iconsLight.color
        self.edgesForExtendedLayout = UIRectEdge()
    }

    override func configureCell(_ cell: ButtonBarViewCell, indicatorInfo: IndicatorInfo) {
        super.configureCell(cell, indicatorInfo: indicatorInfo)

        guard let image = cell.imageView,
            let label = cell.label,
            let sv = image.superview else { return }

        image.removeFromSuperview()
        image.removeConstraints(image.constraints)
        sv.addSubview(image)
        sv.addConstraints([
            NSLayoutConstraint(item: image, attribute: .top, relatedBy: .equal, toItem: sv, attribute: .top, multiplier: 1.0, constant: 6.0),
            NSLayoutConstraint(item: image, attribute: .left, relatedBy: .equal, toItem: sv, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: image, attribute: .bottom, relatedBy: .equal, toItem: sv, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: image, attribute: .right, relatedBy: .equal, toItem: sv, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])

        label.removeFromSuperview()
        label.removeConstraints(label.constraints)
        sv.addSubview(label)
        sv.addConstraints([
            NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: sv, attribute: .top, multiplier: 1.0, constant: 6.0),
            NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: sv, attribute: .left, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: sv, attribute: .bottom, multiplier: 1.0, constant: 0.0),
            NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: sv, attribute: .right, multiplier: 1.0, constant: 0.0)
        ])
    }

    override public func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return controllers
    }
}

extension UIViewController: IndicatorInfoProvider {
    public func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: tabBarItem.title ?? Self.identifier)
    }
}
