//
//  AnnotationViewModel.swift
//  TReader
//
//  Created by tadas on 2020-05-26.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AnnotationViewModel {
    let navigator: AnnotationNavigator

    init (navigator: AnnotationNavigator) {
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        return Output(disposableDrivers: [])
    }
}

extension AnnotationViewModel {
    struct Input {
    }
    struct Output {
        let disposableDrivers: [Driver<Void>]
    }
}
