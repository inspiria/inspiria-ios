//
//  UIViewController+error.swift
//  TReader
//
//  Created by tadas on 2020-09-20.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var errorBinding: Binder<Error> {
        return Binder<Error>(base, binding: { controller, error in
            let alert = UIAlertController(title: "An error occurred",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            if let parent = controller.parent {
                parent.present(alert, animated: true, completion: nil)
            } else {
                controller.present(alert, animated: true, completion: nil)
            }
        })
    }
}
