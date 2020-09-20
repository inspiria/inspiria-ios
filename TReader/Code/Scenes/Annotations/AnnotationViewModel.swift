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
    private let annotationsUseCase: AnnotationsUseCase
    private let book: Book?

    init (book: Book? = nil, annotationsUseCase: AnnotationsUseCase, navigator: AnnotationNavigator) {
        self.book = book
        self.navigator = navigator
        self.annotationsUseCase = annotationsUseCase
    }

    func transform(input: Input) -> Output {
        let activity = ActivityIndicator()
        let error = ErrorTracker()

        let delete = input.deleteTrigger
            .flatMap {
                self.annotationsUseCase
                    .deleteAnnotation(id: $0)
                    .trackError(error)
                    .trackActivity(activity)
                    .asDriver(onErrorJustReturn: false)
                    .mapToVoid()
        }.startWith(())
        
        let list = [Annotation(id: "", created: Date(), updated: Date(), user: "tadas", uri: "", text: "Test annotation", tags: ["tag"], group: "", target: [])]
        let m = list.compactMap { AnnotationCellModel(annotation: $0, highlight: "") }
        let annotations = Driver.just(m)
        
        let annotations2 = Driver
            .combineLatest(input.searchTrigger, input.sortTrigger, input.refreshTrigger, delete)
            .flatMap { str, order, _, _ in
                self.annotationsUseCase
                    .getAnnotations(shortName: self.book?.info.shortName, quote: str)
                    .map {
                        $0.sorted(by: order)
                    }
                    .trackError(error)
                    .trackActivity(activity)
                    .asDriver(onErrorJustReturn: [])
                    .map { $0.map { AnnotationCellModel(annotation: $0, highlight: str) } }
        }

        let edit = annotations.map { $0.map { $0.edit.do(onNext: self.navigator.toEdit).mapToVoid() } }

        return Output(annotations: annotations, edits: edit, delete: delete, activity: activity.asDriver(), error: error.asDriver())
    }
}

extension AnnotationViewModel {
    struct Input {
        let searchTrigger: Driver<String?>
        let sortTrigger: Driver<SortView.Order>
        let deleteTrigger: Driver<String>
        let refreshTrigger: Driver<Void>
    }

    struct Output {
        let annotations: Driver<[AnnotationCellModel]>
        let edits: Driver<[Driver<Void>]>
        let delete: Driver<Void>
        let activity: Driver<Bool>
        let error: Driver<Error>
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
