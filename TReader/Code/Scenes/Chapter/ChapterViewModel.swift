//
//  ChapterViewModel.swift
//  TReader
//
//  Created by tadas on 2020-03-05.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum JSAction: String {
    case annotate, highlight, select
}

class ChapterViewModel {
    let chapter: Chapter
    private let book: Book
    private let navigator: ChaptersNavigator
    private let booksUseCase: BooksUseCase
    private let annotationsUseCase: AnnotationsUseCase

    init (chapter: Chapter,
          book: Book,
          navigator: ChaptersNavigator,
          booksUseCase: BooksUseCase,
          annotationsUseCase: AnnotationsUseCase) {
        self.book = book
        self.chapter = chapter
        self.navigator = navigator
        self.booksUseCase = booksUseCase
        self.annotationsUseCase = annotationsUseCase
    }

    func transform(input: Input) -> Output {
        let activity = ActivityIndicator()
        let error = ErrorTracker()
        let refresh = BehaviorSubject<Void>(value: ())

        let chapter = Driver
            .combineLatest(input.trigger, Driver.just(self.chapter)) { $1 }
        let annotations = refresh.flatMap {
            self.annotationsUseCase
                .getAnnotations(shortName: "\(self.book.info.shortName)/\(self.chapter.shortName)", quote: nil)
                .trackActivity(activity)
        }
        .asDriver(onErrorJustReturn: [])
        let openChapter = input.openChapter
            .flatMap { [unowned self] (data) -> Driver<(Int, Book)> in
                self.booksUseCase.book(id: data.0)
                    .map { (data.1, $0) }
                    .asObservable()
                    .asDriverOnErrorJustComplete()
        }
        .do(onNext: self.navigator.to)
        .mapToVoid()

        let edit = input.annotationAction
            .filter { $0.0 == .select }
            .map { $0.1.id }
            .filterNil()
            .withLatestFrom(annotations) { id, ann in ann.filter { $0.id == id }.first }
            .filterNil()
            .flatMap { ann in
                self.navigator
                    .toEdit(annotation: ann)
                    .map { AnnotationUpdate(id: ann.id, updated: ann.updated, text: $0 ) }
            }.flatMap { update in
                self.annotationsUseCase
                    .updateAnnotation(update: update)
                    .trackError(error)
                    .trackActivity(activity)
                    .asDriverOnErrorJustComplete()
            }
            .mapToVoid()
            .do(onNext: refresh.onNext)
        let add = input.annotationAction
            .filter { $0.0 == .highlight }
            .map { AnnotationCreate(uri: "https://edtechbooks.org/\(self.book.info.shortName)/\(self.chapter.shortName)", text: "", annotation: $0.1) }
            .flatMap { create in
                self.annotationsUseCase
                    .createAnnotation(create: create)
                    .trackError(error)
                    .trackActivity(activity)
                    .asDriverOnErrorJustComplete()
            }
            .mapToVoid()
            .do(onNext: refresh.onNext)
        let addWithText = input.annotationAction
            .filter { $0.0 == .annotate }
            .map { AnnotationCreate(uri: "https://edtechbooks.org/\(self.book.info.shortName)/\(self.chapter.shortName)", text: "", annotation: $0.1) }
            .flatMap { ann in
                self.navigator
                    .toEdit(annotation: ann)
                    .map { str -> AnnotationCreate in  var annotation = ann; annotation.text = str; return annotation }
            }.flatMap { create in
                self.annotationsUseCase
                    .createAnnotation(create: create)
                    .trackError(error)
                    .trackActivity(activity)
                    .asDriverOnErrorJustComplete()
            }
            .mapToVoid()
            .do(onNext: refresh.onNext)

        return Output(chapter: chapter,
                      annotations: annotations,
                      activity: activity.asDriver(),
                      error: error.asDriver(),
                      drivers: [openChapter, edit, add, addWithText])
    }
}

extension ChapterViewModel {
    struct Input {
        let trigger: Driver<Void>
        let openChapter: Driver<(Int, Int)>
        let annotationAction: Driver<(JSAction, JSAnnotation)>
    }
    struct Output {
        let chapter: Driver<Chapter>
        let annotations: Driver<[Annotation]>
        let activity: Driver<Bool>
        let error: Driver<Error>
        let drivers: [Driver<Void>]
    }
}
