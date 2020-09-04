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

class EditAnnontationViewModel {
    private let navigator: EditAnnotationNavigator
    private let annotation: Annotationable

    private let finalTextBehaviorRelay = BehaviorRelay<String>(value: "")
    var updatedText: Single<String> {
        finalTextBehaviorRelay
            .asObservable().skip(1)
            .asSingle()
    }

    init (navigator: EditAnnotationNavigator, annotation: Annotationable) {
        self.navigator = navigator
        self.annotation = annotation
    }

    func transform(input: Input) -> Output {
        return Output(disposableDrivers: [])
    }
}

extension EditAnnontationViewModel {
    struct Input {
    }
    struct Output {
        let disposableDrivers: [Driver<Void>]
    }
}
