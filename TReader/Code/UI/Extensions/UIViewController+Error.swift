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
            if case AnnotationsError.noUserProfile = error {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let title = "Unauthenticated"
                    let message = "\nInspiria uses Hypothes.is to annotate text within the app.\nLogin with your Hypothes.is account to use this feature."
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                    alert.addAction(UIAlertAction(title: "Authenticate", style: .default) { _ in
                        if let scene = UIApplication.shared.connectedScenes.first,
                           let delegate = scene.delegate as? SceneDelegate {
                            delegate.openSettings()
                        }
                    })
                    if let top = controller.presentedViewController {
                        top.present(alert, animated: true, completion: nil)
                    } else {
                        controller.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                let alert = UIAlertController(title: "An error occurred", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                if let top = controller.presentedViewController {
                    top.present(alert, animated: true, completion: nil)
                } else {
                    controller.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
}
