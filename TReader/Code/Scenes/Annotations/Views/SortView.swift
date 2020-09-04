//
//  SortView.swift
//  TReader
//
//  Created by tadas on 2020-05-28.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

private func _window() -> UIView? {
    return UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .map({$0 as? UIWindowScene})
        .compactMap({$0})
        .first?.windows
        .filter({$0.isKeyWindow}).first
}

class SortView: UIView, NibLoadable {
    enum Order {
        case newest, oldest, ascending, descending
    }

    @IBOutlet var container: UIView!
    @IBOutlet var anchor: UIView!
    @IBOutlet var newestButton: UIButton!
    @IBOutlet var oldestButton: UIButton!
    @IBOutlet var ascendingButton: UIButton!
    @IBOutlet var descendingButton: UIButton!

    override func awakeFromNib() {
        let cornerRadius: CGFloat = 3.0
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOpacity = 0.25
        container.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        container.layer.shadowRadius = 2
        container.layer.cornerRadius = cornerRadius
    }

    class func show(in view: UIView, at point: CGPoint) -> Driver<Order> {
        guard let window = _window() else { return Driver.just(.newest) }

        let container = UIView(frame: window.bounds)
        let sortView = SortView.fromNib()
        container.backgroundColor = .clear

        window.addSubview(container)

        let x = point.x - sortView.anchor.frame.minX - sortView.anchor.frame.width/2
        sortView.frame.origin = view.convert(CGPoint(x: x, y: point.y), to: container)
        container.addSubview(sortView)

        container
            .rx.tapGesture()
            .asDriver()
            .skip(1)
            .drive(onNext: { [weak container] _ in container?.removeFromSuperview() })
            .disposed(by: sortView.rx.disposeBag)

        let newest = sortView.newestButton.rx.tap.asDriver().map { _ in return Order.newest }
        let oldest = sortView.oldestButton.rx.tap.asDriver().map { _ in return Order.oldest }
        let ascending = sortView.ascendingButton.rx.tap.asDriver().map { _ in return Order.ascending }
        let descending = sortView.descendingButton.rx.tap.asDriver().map { _ in return Order.descending }

        return Driver.merge(newest, oldest, ascending, descending)
            .do(onNext: { [weak container] _ in container?.removeFromSuperview() })
    }
}
