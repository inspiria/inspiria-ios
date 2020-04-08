//
//  DeepLink.swift
//  TReader
//
//  Created by tadas on 2020-04-08.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

enum DeepLink {
    case chapter(Int, Int)

    init?(string: String) {
        guard let url = URL(string: string) else { return nil }
        self.init(url: url)
    }

    init?(url: URL) {
        switch url.host {
        case "chapter":
            guard let bookId = url.value(of: "bookId").flatMap({Int($0)}),
                let chapterId = url.value(of: "chapterId").flatMap({Int($0)}) else { return nil }
            self = .chapter(bookId, chapterId)
        default: return nil
        }
    }
}

extension URL {
    func value(of queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
