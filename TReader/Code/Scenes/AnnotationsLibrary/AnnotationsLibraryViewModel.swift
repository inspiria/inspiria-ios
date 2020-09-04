//
//  AnnotationsLibraryViewModel.swift
//  TReader
//
//  Created by tadas on 2020-09-04.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AnnotationsLibraryViewModel {
    private let navigator: AnnotationsLibraryNavigator
    private let annotationsUseCase: AnnotationsUseCase


    init (navigator: AnnotationsLibraryNavigator,
          annotationsUseCase: AnnotationsUseCase) {
        self.navigator = navigator
        self.annotationsUseCase = annotationsUseCase
    }

    func transform(input: Input) -> Output {
        let annotations = Driver
            .combineLatest(input.searchTrigger, input.sortTrigger, input.refreshTrigger, delete)
            .flatMap { str, order, _, _ in
                self.annotationsUseCase.getAnnotations(shortName: self.book.info.shortName, quote: str)
                    .map { $0.sorted(by: order) }
                    .trackActivity(activity)
                    .asDriver(onErrorJustReturn: [])
                    .map { $0.map { AnnotationCellModel(annotation: $0, highlight: str) } }
        }

        return Output(annotations: annotations)
    }
}

extension AnnotationsLibraryViewModel {
    struct Input {
    }
    struct Output {
        let annotations: Driver<[AnnotationCellModel]>
    }
}
