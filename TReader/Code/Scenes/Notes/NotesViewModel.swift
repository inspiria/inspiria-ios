//
//  NotesViewModel.swift
//  TReader
//
//  Created by tadas on 2020-05-26.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NotesViewModel {
    let navigator: NotesNavigator

    init (navigator: NotesNavigator) {
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        return Output(disposableDrivers: [])
    }
}

extension NotesViewModel {
    struct Input {
    }
    struct Output {
        let disposableDrivers: [Driver<Void>]
    }
}
