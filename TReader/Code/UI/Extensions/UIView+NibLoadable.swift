//
//  UIView+NibLoadable.swift
//  TReader
//
//  Created by tadas on 2020-05-28.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

public protocol NibLoadable: class {
    static var nibName: String { get }
}

// MARK: - From Nib

public extension NibLoadable where Self: UIView {
    
    static var nibName: String {
         return String(describing: self)
    }

    static func fromNib() -> Self {
        guard let nib = Bundle(for: self).loadNibNamed(nibName, owner: nil, options: nil) else {
            fatalError("Failed loading the nib named \(nibName) for 'NibLoadable' view of type '\(self)'.")
        }
        guard let view = (nib.first { $0 is Self }) as? Self else {
            fatalError("Did not find 'NibLoadable' view of type '\(self)' inside '\(nibName).xib'.")
        }
        return view
    }
}
