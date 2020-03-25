//
//  BooksListUseCase.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BooksUseCase {
    func fetchBooks() -> Single<Void>
    func books() -> Observable<[BookInfo]>

    func isBookDownloaded(id: Int) -> Bool
    func downloadBook(id: Int) -> Observable<Double>

    func book(id: Int) -> Single<Book>

    func remove(id: Int) -> Bool
}

class DefaultBooksUseCase: BooksUseCase {
    private let networkService: NetworkService
    private let bookStorage: BooksStorage
    private let booksRelay: BehaviorRelay<[BookInfo]>

    init(networkService: NetworkService, bookStorage: BooksStorage) {
        self.networkService = networkService
        self.bookStorage = bookStorage
        self.booksRelay = BehaviorRelay<[BookInfo]>.init(value: bookStorage.getBooksList())
    }

    func fetchBooks() -> Single<Void> {
        let list: Single<[BookInfo]> = networkService.request(path: "books", method: .get)
        return list.do(onSuccess: { [unowned self] books in
            self.bookStorage.saveBooksList(books: books)
            self.booksRelay.accept(books)
        }).map { _ in () }
    }

    func books() -> Observable<[BookInfo]> {
        return booksRelay.asObservable()
    }

    func isBookDownloaded(id: Int) -> Bool {
        return bookStorage.bookFilesExists(id: id)
    }

    func downloadBook(id: Int) -> Observable<Double> {
        return networkService
            .fileRequest(path: "book/\(id)")
            .flatMap { [unowned self] download -> Observable<Double> in
                if download.progress == 1.0 {
                    guard let data = download.data else {
                        let error = NetworkError.response("Failed to retreive book data. Please check zip format")
                        return Observable.error(error)
                    }
                    return self.bookStorage
                        .storeBook(id: id, data: data)
                        .map { $0*0.15 + 0.85 }
                }
                return Observable.just(download.progress*0.75)
            }
    }

    func book(id: Int) -> Single<Book> {
        return bookStorage.getBook(id: id)
    }

    func remove(id: Int) -> Bool {
        return bookStorage.remove(id: id)
    }
}
