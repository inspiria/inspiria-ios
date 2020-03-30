//
//  Storyboard.swift
//  TReader
//
//  Created by tadas on 2020-02-23.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>() -> T {
        guard let controller = instantiateViewController(withIdentifier: T.identifier) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return controller
    }
}
