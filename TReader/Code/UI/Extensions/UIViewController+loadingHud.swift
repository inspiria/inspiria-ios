//
//  UIViewController+loadingHud.swift
//  TReader
//
//  Created by tadas on 2020-06-13.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let aHudTag = 998998
extension Reactive where Base: UIViewController {
    public var isRefreshing: Binder<Bool> {
        return Binder(self.base) { controller, refreshing in
            let view = controller.navigationController?.view ?? controller.view!
            if refreshing {
                let hud = UIView(frame: view.bounds)
                let acitvityIndicator = UIActivityIndicatorView(style: .medium)
                acitvityIndicator.center = hud.center
                acitvityIndicator.startAnimating()

                hud.tag = aHudTag
                hud.backgroundColor = UIColor.black.withAlphaComponent(0.3)
                hud.addSubview(acitvityIndicator)
                view.addSubview(hud)
            } else {
                view.viewWithTag(aHudTag)?.removeFromSuperview()
            }
        }
    }
}
