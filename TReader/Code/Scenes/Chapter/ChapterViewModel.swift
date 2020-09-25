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
        let chapter = Driver
            .combineLatest(input.trigger, Driver.just(self.chapter)) { $1 }
        let annotations = self.annotationsUseCase
            .getAnnotations(shortName: "\(self.book.info.shortName)/\(self.chapter.shortName)", quote: nil)
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

        return Output(chapter: chapter,
                      annotations: annotations,
                      openChapter: openChapter)
    }

    func add(annotation: JSAnnotation) {
        let selector = AnnotationSelector.quote(TextQuoteSelector(exact: annotation.exact,
                                                                  prefix: annotation.prefix,
                                                                  suffix: annotation.suffix))
        let target = AnnotationTarget(source: "", selector: [selector])
        let ann = Annotation(id: "0",
                             created: Date(),
                             updated: Date(), user: "acc:tadas@malka.lt",
                             uri: "",
                             text: "",
                             tags: [],
                             group: "",
                             target: [target])
        navigator.toEdit(annotation: ann)
    }

    func add(highlight: JSAnnotation) {
    }

    func edit(annotation id: String) {
//        navigator.toCreate(annotation: annotation)
    }
}

extension ChapterViewModel {
    struct Input {
        let trigger: Driver<Void>
        let openChapter: Driver<(Int, Int)>
    }
    struct Output {
        let chapter: Driver<Chapter>
        let annotations: Driver<[Annotation]>
        let openChapter: Driver<Void>
    }
}
