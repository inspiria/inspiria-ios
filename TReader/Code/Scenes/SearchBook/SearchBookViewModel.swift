//
//  SearchBookViewModel.swift
//  TReader
//
//  Created by tadas on 2020-09-04.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SearchItem {
    let model: BookSearchResult
    let highlight: String?
}

class SearchBookViewModel {
    let book: Book
    let navigator: SearchBookNavigator
    let searchUseCase: BookSearchUseCase

    init (book: Book, searchUseCase: BookSearchUseCase, navigator: SearchBookNavigator) {
        self.book = book
        self.searchUseCase = searchUseCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let activityTracker = ActivityIndicator()
        let items = input.searchTrigger
            .distinctUntilChanged()
            .flatMap { query -> Driver<[SearchItem]> in
                guard query.count > 3 else { return Driver.just([]) }
                return self.searchUseCase
                    .search(query: query, in: self.book)
                    .trackActivity(activityTracker)
                    .asDriver(onErrorJustReturn: [])
                    .map { $0.map { SearchItem(model: $0, highlight: query) } }
            }
        let selected = input.itemSelected
            .map { ($0.model.chapterId, self.book) }
            .do(onNext: navigator.to)
            .mapToVoid()

        let title = Driver.just(book.info.title)

        return Output(title: title,
                      items: items,
                      selected: selected,
                      activity: activityTracker.asDriver())
    }
}

extension SearchBookViewModel {
    struct Input {
        let searchTrigger: Driver<String>
        let itemSelected: Driver<SearchItem>
    }
    struct Output {
        let title: Driver<String>
        let items: Driver<[SearchItem]>
        let selected: Driver<Void>
        let activity: Driver<Bool>
    }
}
