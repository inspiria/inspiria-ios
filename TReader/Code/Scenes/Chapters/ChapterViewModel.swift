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

    init (chapter: Chapter) {
        self.chapter = chapter
    }

    func transform(input: Input) -> Output {
        return Output(chapter: Driver.just(chapter))
    }
}

extension ChapterViewModel {
    struct Input {
    }
    struct Output {
        let chapter: Driver<Chapter>
    }
}
