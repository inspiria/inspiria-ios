//
//  EditNoteViewModel.swift
//  TReader
//
//  Created by tadas on 2020-07-14.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EditNoteViewModel {
    let navigator: EditNoteNavigator

    init (navigator: EditNoteNavigator) {
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        return Output(disposableDrivers: [])
    }
}

extension EditNoteViewModel {
    struct Input {
    }
    struct Output {
        let disposableDrivers: [Driver<Void>]
    }
}
