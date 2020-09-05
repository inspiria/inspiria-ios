//
//  SearchBookViewModel.swift
//  TReader
//
//  Created by tadas on 2020-09-04.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchBookViewModel {
    let navigator: SearchBookNavigator

    init (navigator: SearchBookNavigator) {
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        return Output(disposableDrivers: [])
    }
}

extension SearchBookViewModel {
    struct Input {
    }
    struct Output {
        let disposableDrivers: [Driver<Void>]
    }
}
