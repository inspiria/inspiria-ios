//
//  Font.swift
//  TReader
//
//  Created by tadas on 2020-03-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

protocol TextStylable {
    var font: UIFont { get }
    var lineHeight: CGFloat { get }
}

class TextStyle {
    enum Book: String, TextStylable, CaseIterable {
        case h1
        case h2
        case h3
        case h4
        case bodyText
        case calloutQuote
        case captions

        var font: UIFont {
            switch self {
            case .h1: return UIFont.readingH1
            case .h2: return UIFont.readingH2
            case .h3: return UIFont.readingH3
            case .h4: return UIFont.readingH4
            case .bodyText: return UIFont.readingBodyText
            case .calloutQuote: return UIFont.readingCalloutQuote
            case .captions: return UIFont.readingCaptions
            }
        }

        var lineHeight: CGFloat {
            switch self {
            case .h1: return 30.0
            case .h2: return 27.0
            case .h3: return 24.0
            case .h4: return 24.0
            case .bodyText: return 21.0
            case .calloutQuote: return 24.0
            case .captions: return 14
            }
        }
    }
}

fileprivate extension UIFont {
    static var readingH1: UIFont = {
        return UIFont(name: "NotoSerif-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold)
    }()

    static var readingH2: UIFont = {
        return UIFont(name: "NotoSerif-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
    }()

    static var readingH3: UIFont = {
        return UIFont(name: "NotoSerif-Bold", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .bold)
    }()

    static var readingH4: UIFont = {
        return UIFont(name: "NotoSerif-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
    }()

    static var readingBodyText: UIFont = {
        return UIFont(name: "NotoSerif-Regular", size: 14.0) ?? UIFont.systemFont(ofSize: 14, weight: .regular)
    }()

    static var readingCalloutQuote: UIFont = {
        return UIFont(name: "NotoSerif-Italic", size: 16.0) ?? UIFont.systemFont(ofSize: 14, weight: .thin)
    }()

    static var readingCaptions: UIFont = {
        return UIFont(name: "NotoSerif-Regular", size: 12.0) ?? UIFont.systemFont(ofSize: 12, weight: .regular)
    }()
}
