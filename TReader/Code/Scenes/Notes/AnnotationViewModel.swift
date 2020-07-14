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
    private let book: Book

    init (book: Book, hypothesisUseCase: HypothesisUseCase, navigator: AnnotationNavigator) {
        self.book = book
        self.navigator = navigator
        self.hypothesisUseCase = hypothesisUseCase
    }

    func transform(input: Input) -> Output {
        let activity = ActivityIndicator()
        let annotations = Driver
            .combineLatest(input.searchTrigger, input.sortTrigger, input.refreshTrigger)
            .flatMap { str, order, _ in
                self.hypothesisUseCase.getAnnotations(shortName: self.book.info.shortName, quote: str)
                    .map { $0.sorted(by: order) }
                    .trackActivity(activity)
                    .asDriver(onErrorJustReturn: [])
                    .map { $0.map { AnnotationCellModel(annotation: $0, highlight: str) } }
        }

        let delete = annotations.map { $0.map { $0.delete.mapToVoid() } }
        let edit = annotations.map { $0.map { $0.edit.do(onNext: self.navigator.toEdit).mapToVoid() } }

        return Output(annotations: annotations, deletions: delete, edits: edit, activity: activity.asDriver())
    }
}

extension AnnotationViewModel {
    struct Input {
        let searchTrigger: Driver<String?>
        let sortTrigger: Driver<SortView.Order>
        let refreshTrigger: Driver<Void>
    }

    struct Output {
        let annotations: Driver<[AnnotationCellModel]>
        let deletions: Driver<[Driver<Void>]>
        let edits: Driver<[Driver<Void>]>
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
