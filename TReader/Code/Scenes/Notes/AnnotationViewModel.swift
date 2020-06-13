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
        let activity = ActivityIndicator()
        let annotations = Driver
            .combineLatest(input.searchTrigger.debug(), input.sortTrigger, input.refreshTrigger)
            .flatMap { str, order, _ in
                self.hypothesisUseCase.getAnnotations(quote: str)
                    .map { $0.sorted(by: order) }
                    .trackActivity(activity)
                    .asDriver(onErrorJustReturn: [])
        }
        return Output(annotations: annotations, activity: activity.asDriver())
    }
}

extension AnnotationViewModel {
    struct Input {
        let searchTrigger: Driver<String?>
        let sortTrigger: Driver<SortView.Order>
        let refreshTrigger: Driver<Void>
    }
    struct Output {
        let annotations: Driver<[Annotation]>
        let activity: Driver<Bool>
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
