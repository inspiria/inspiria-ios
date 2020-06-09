//
//  ChaptersViewModel.swift
//  TReader
//
//  Created by tadas on 2020-06-03.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ChaptersViewModel {
    private let book: Book
    private let navigator: ChaptersNavigator
    private let booksUseCase: BooksUseCase
    private var bookmarkUseCase: BookmarkUseCase!
    private let chapterId: Int

    init (book: Book,
          chapterId: Int,
          navigator: ChaptersNavigator,
          booksUseCase: BooksUseCase,
          bookmarkUseCase: BookmarkUseCase) {
        self.book = book
        self.navigator = navigator
        self.booksUseCase = booksUseCase
        self.chapterId = chapterId
        self.bookmarkUseCase = bookmarkUseCase
    }

    func transform(input: Input) -> Output {
        let toContent = input.toContent
            .do(onNext: navigator.toBook)
        let search = input.search
            .do(onNext: navigator.toSearch)
        let bookmarkValue = input.chapter
            .map { [unowned self] in self.bookmarkUseCase.bookmark(book: self.book.info.id, chapter: $0) != nil }
        let bookmarkAction = input.addBookmark
            .withLatestFrom(input.chapter)
            .map { [unowned self] in (self.bookmarkUseCase.bookmark(book: self.book.info.id, chapter: $0), $0) }
            .map { [unowned self] arg -> Bool in
                if let bookmark = arg.0 {
                    self.bookmarkUseCase.remove(bookmark: bookmark)
                    return false
                } else if let bookmark = self.bookmark(arg.1) {
                    self.bookmarkUseCase.add(bookmark: bookmark)
                    return true
                }
                return false
        }
        let hasBookmark = Driver.merge(bookmarkValue, bookmarkAction)

        return Output(initChapter: chapterId,
                      hasBookmark: hasBookmark,
                      drivers: [toContent, search])
    }
}

extension ChaptersViewModel {
    func previousChapterViewController(_ chapterId: Int) -> UIViewController? {
        guard let index = book.chapters.firstIndex(where: { $0.id == chapterId }) else { return nil }
        guard index > 0 else { return nil }
        let chapter = book.chapters[index-1]
        return navigator.chapterViewController(chapter: chapter, book: book)
    }

    func nextChapterViewController(_ chapterId: Int) -> UIViewController? {
        guard let index = book.chapters.firstIndex(where: { $0.id == chapterId }) else { return nil }
        guard index < book.chapters.count - 1 else { return nil }
        let chapter = book.chapters[index+1]
        return navigator.chapterViewController(chapter: chapter, book: book)
    }

    func bookmark(_ chapterId: Int) -> Bookmark? {
        if let index = book.chapters.firstIndex(where: { $0.id == chapterId }) {
            let title = book.chapters[index].title
            return Bookmark(title: title, date: Date(), bookId: book.info.id, chapterId: chapterId, page: index+1)
        }
        return nil
    }
}

extension ChaptersViewModel {
    struct Input {
        let toContent: Driver<Void>
        let search: Driver<Void>
        let addBookmark: Driver<Void>
        let chapter: Driver<Int>
    }
    struct Output {
        let initChapter: Int
        let hasBookmark: Driver<Bool>
        let drivers: [Driver<Void>]
    }
}
