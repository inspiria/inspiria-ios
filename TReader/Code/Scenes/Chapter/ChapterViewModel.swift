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
    let navigator: ChaptersNavigator
    let booksUseCase: BooksUseCase

    init (chapter: Chapter,
          navigator: ChaptersNavigator,
          booksUseCase: BooksUseCase) {
        self.chapter = chapter
        self.navigator = navigator
        self.booksUseCase = booksUseCase
    }

    func transform(input: Input) -> Output {
        let chapter = Driver
            .combineLatest(input.trigger, Driver.just(self.chapter)) { $1 }
        let openChapter = input.openChapter
            .flatMap { [unowned self] (data) -> Driver<(Int, Book)> in
                self.booksUseCase.book(id: data.0)
                    .map { (data.1, $0) }
                    .asObservable()
                    .asDriverOnErrorJustComplete()
        }
        .do(onNext: self.navigator.to)
        .mapToVoid()

        return Output(chapter: chapter, openChapter: openChapter)
    }
}

extension ChapterViewModel {
    struct Input {
        let trigger: Driver<Void>
        let openChapter: Driver<(Int, Int)>
    }
    struct Output {
        let chapter: Driver<Chapter>
        let openChapter: Driver<Void>
    }
}
