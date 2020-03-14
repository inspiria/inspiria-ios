//
//  Font.swift
//  TReader
//
//  Created by tadas on 2020-03-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class TextStyle {
    enum Book: String, CaseIterable {
        case h1
        case h2
        case h3
        case h4
        case bodyText
        case calloutQuote
        case captions
        
        var font: UIFont {
            switch self {
            case .h1: return UIFont.reading_h1
            case .h2: return UIFont.reading_h2
            case .h3: return UIFont.reading_h3
            case .h4: return UIFont.reading_h4
            case .bodyText: return UIFont.reading_bodyText
            case .calloutQuote: return UIFont.reading_calloutQuote
            case .captions: return UIFont.reading_captions
            }
        }
    }
}

fileprivate extension UIFont {
    static var reading_h1: UIFont = {
        return UIFont(name: "NotoSerif-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold)
    }()

    static var reading_h2: UIFont = {
        return UIFont(name: "NotoSerif-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
    }()

    static var reading_h3: UIFont = {
        return UIFont(name: "NotoSerif-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
    }()

    static var reading_h4: UIFont = {
        return UIFont(name: "NotoSerif-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
    }()

    static var reading_bodyText: UIFont = {
        return UIFont(name: "NotoSerif-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    }()

    static var reading_calloutQuote: UIFont = {
        return UIFont(name: "NotoSerif-Italic", size: 16.0) ?? UIFont.systemFont(ofSize: 14, weight: .thin)
    }()

    static var reading_captions: UIFont = {
        return UIFont(name: "NotoSerif-Regular", size: 12.0) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
    }()
}
