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
        let items = input.searchTrigger
            .flatMap { query -> Driver<[SearchItem]> in
                guard let query = query, query.count > 0 else { return Driver.just([]) }
                return self.searchUseCase
                    .search(query: query, in: self.book)
                    .asDriver(onErrorJustReturn: [])
                    .map { $0.map { SearchItem(model: $0, highlight: query) } }
            }
        let selected = input.itemSelected.mapToVoid()

        return Output(items: items, selected: selected)
    }
}

extension SearchBookViewModel {
    struct Input {
        let searchTrigger: Driver<String?>
        let itemSelected: Driver<Int>
    }
    struct Output {
        let items: Driver<[SearchItem]>
        let selected: Driver<Void>
    }
}
