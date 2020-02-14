//
//  ColorStyle.swift
//  TReader
//
//  Created by tadas on 2020-02-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

enum ColorStyle: CaseIterable {
    case textGray
    case orange
    case menuGray
    case menuDark
    case bkgrndWhite

    var color: UIColor {
        switch self {
        case .textGray: return UIColor.textGray
        case .orange: return UIColor.orange
        case .menuGray: return UIColor.menuGray
        case .menuDark: return UIColor.menuDark
        case .bkgrndWhite: return UIColor.bkgrndWhite
        }
    }
}

fileprivate extension UIColor {
    @nonobjc class var textGray: UIColor {
        return UIColor.init(named: "TextGray")!
    }

    @nonobjc class var orange: UIColor {
        return UIColor.init(named: "Orange")!
    }

    @nonobjc class var menuGray: UIColor {
        return UIColor.init(named: "MenuGray")!
    }

    @nonobjc class var menuDark: UIColor {
        return UIColor.init(named: "MenuDark")!
    }

    @nonobjc class var bkgrndWhite: UIColor {
        return UIColor.init(named: "BkgrndWhite")!
    }
}