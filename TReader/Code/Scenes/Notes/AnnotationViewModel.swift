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
    private let navigator: AnnotationNavigator
    private let hypothesisUseCase: HypothesisUseCase

    init (navigator: AnnotationNavigator, hypothesisUseCase: HypothesisUseCase) {
        self.navigator = navigator
        self.hypothesisUseCase = hypothesisUseCase
    }

    func transform(input: Input) -> Output {
        let annotations = Driver
            .combineLatest(input.searchTrigger.debug(), input.sortTrigger)
            .flatMap { str, order in
                self.hypothesisUseCase.getAnnotations(quote: str)
                    .map { $0.sorted(by: order) }
                    .debug()
                    .asDriver(onErrorJustReturn: [])
        }
        return Output(annotations: annotations)
    }
}

extension AnnotationViewModel {
    struct Input {
        let searchTrigger: Driver<String?>
        let sortTrigger: Driver<SortView.Order>
    }
    struct Output {
        let annotations: Driver<[Annotation]>
    }
}

extension Array where Element == Annotation {
    func sorted(by order: SortView.Order) -> Self {
        switch order {
        case .newest: return sorted { $0.updated > $1.updated }
        case .oldest: return sorted { $0.updated < $1.updated }
        case .ascending: return sorted { $0.quote < $1.quote }
        case .descending: return sorted { $0.quote > $1.quote }
        }
    }
}
