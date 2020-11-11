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
    private let annotation: AnnotationCellModel

    var updatedText: Driver<String> {
        return annotation.save
            .do(onNext: { [unowned self] _ in self.navigator.cancelEdit() })
    }

    init (navigator: EditAnnotationNavigator, annotation: Annotationable) {
        self.navigator = navigator
        self.annotation = AnnotationCellModel(annotation: annotation, edit: true)
    }

    func transform() -> Output {
        let annotations = Driver.just([annotation])
        let cancel = annotation.cancel
            .do(onNext: navigator.cancelEdit)
        return Output(annotations: annotations,
                      cancel: cancel)
    }
}

extension EditAnnontationViewModel {
    struct Output {
        let annotations: Driver<[AnnotationCellModel]>
        let cancel: Driver<Void>
    }
}
