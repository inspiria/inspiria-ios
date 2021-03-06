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
    case textDark
    case orange
    case menuGray
    case menuDark
    case bkgrndWhite
    case iconsLight
    case readingUnderline
    case darkGray
    case lightBackground

    var color: UIColor {
        switch self {
        case .textGray: return UIColor.textGray
        case .textDark: return UIColor.textDark
        case .orange: return UIColor.orange
        case .menuGray: return UIColor.menuGray
        case .menuDark: return UIColor.menuDark
        case .bkgrndWhite: return UIColor.bkgrndWhite
        case .iconsLight: return UIColor.iconsLight
        case .readingUnderline: return UIColor.readingUnderline
        case .darkGray: return UIColor.darkGray
        case .lightBackground: return UIColor.lightBackground
        }
    }
}

fileprivate extension UIColor {
    @nonobjc class var textGray: UIColor {
        return UIColor.init(named: "TextGray")!
    }

    @nonobjc class var textDark: UIColor {
        return UIColor.init(named: "TextDark")!
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

    @nonobjc class var iconsLight: UIColor {
        return UIColor.init(named: "IconsLight")!
    }

    @nonobjc class var readingUnderline: UIColor {
        return UIColor.init(named: "ReadingUnderline")!
    }

    @nonobjc class var darkGray: UIColor {
        return UIColor.init(named: "DarkGray")!
    }

    @nonobjc class var lightBackground: UIColor {
        return UIColor.init(named: "LightBackground")!
    }
}
