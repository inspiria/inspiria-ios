//
//  BooksListViewModel.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class BooksListViewModel {
    private let booksUseCase: BooksUseCase
    private let navigator: BooksListNavigator

    init (booksUseCase: BooksUseCase, navigator: BooksListNavigator) {
        self.booksUseCase = booksUseCase
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let books = booksUseCase.books()
            .map { [unowned self] in
                $0.enumerated().map { BooksListItemViewModel(useCase: self.booksUseCase, book: $0.element, index: $0.offset) }}
            .asDriver(onErrorJustReturn: [])

        let fetch = booksUseCase
            .fetchBooks()
            .asDriver(onErrorJustReturn: ())

        let select = input.onSelect
            .withLatestFrom(input.canEdit) { ($0, $1) }
            .filter { $0.1 }
            .withLatestFrom(books) { $1[$0.0] }
            .filter { $0.isDownloaded }
            .do(onNext: { $0.state.accept($0.state.value.isSelected ? .deselected : .selected)})
            .mapToVoid()

        let enable = input.canEdit
            .withLatestFrom(books) { ($0, $1.filter { $0.isDownloaded }) }
            .do(onNext: { args in args.1.forEach { $0.state.accept(args.0 ? .deselected : .downloaded) }})
            .mapToVoid()

        let download = input.onSelect
            .withLatestFrom(input.canEdit) { ($0, $1) }
            .filter { !$0.1 }
            .withLatestFrom(books) { $1[$0.0] }
            .filter { !$0.isDownloaded }
            .do(onNext: { $0.onDownload.onNext(()) })
            .mapToVoid()

        let open = input.onSelect
            .withLatestFrom(input.canEdit) { ($0, $1) }
            .filter { !$0.1 }
            .withLatestFrom(books) { $1[$0.0] }
            .filter { $0.isDownloaded }
            .map { $0.book }
            .do(onNext: navigator.to)
            .mapToVoid()

        let booksToRemove = input.onSelect
            .withLatestFrom(books)
            .map { $0.filter { $0.state.value.isSelected } }

        let canRemove = booksToRemove
            .map { $0.count > 0 }

        let remove = input.onRemove
            .withLatestFrom(booksToRemove)
            .map { $0.compactMap { model -> Int? in
                model.state.accept(.none)
                return self.booksUseCase.remove(id: model.book.id) ? model.index : nil
            }}

        return Output(books: books,
                      canRemove: canRemove,
                      remove: remove,
                      drivers: [fetch, select, enable, download, open])
    }
}

extension BooksListViewModel {
    struct Input {
        let onSelect: Driver<Int>
        let canEdit: Driver<Bool>
        let onRemove: Driver<Void>
    }
    struct Output {
        let books: Driver<[BooksListItemViewModel]>
        let canRemove: Driver<Bool>
        let remove: Driver<[Int]>
        let drivers: [Driver<Void>]
    }
}
