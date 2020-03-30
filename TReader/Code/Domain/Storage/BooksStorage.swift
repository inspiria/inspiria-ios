//
//  BooksStorage.swift
//  TReader
//
//  Created by tadas on 2020-02-23.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Zip

private let kBooksListStorage = "books.list.storage"

protocol BooksStorage {
    func getBooksList() -> [BookInfo]
    func saveBooksList(books: [BookInfo])
    func bookFilesExists(id: Int) -> Bool

    func storeBook(id: Int, data: Data) -> Observable<Double>
    func getBook(id: Int) -> Single<Book>
    func remove(id: Int) -> Bool
}

class DefaultBooksStorage: BooksStorage {
    private let defaults: UserDefaults
    private let filesService: BookFilesService

    init(userDefaults: UserDefaults, filesService: BookFilesService) {
        self.defaults = userDefaults
        self.filesService = filesService
    }

    func getBooksList() -> [BookInfo] {
        guard let data = defaults.value(forKey: kBooksListStorage) as? Data else { return [] }
        return (try? JSONDecoder().decode([BookInfo].self, from: data)) ?? []
    }

    func saveBooksList(books: [BookInfo]) {
        if let data = try? JSONEncoder().encode(books) {
            defaults.set(data, forKey: kBooksListStorage)
        }
    }

    func storeBook(id: Int, data: Data) -> Observable<Double> {
        let bookUrl = filesService.getBookUrl(id: id)
//        let bookFile = filesService.getBookFileUrl(id: id)
        let zipUrl = filesService.getBookZiptUrl(id: id)
        do {
            try data.write(to: zipUrl)
        } catch {
            return Observable.error(error)
        }
        return Observable.create { [unowned self] observable in
            do {
                try Zip.unzipFile(zipUrl, destination: bookUrl, overwrite: true, password: nil, progress: { progress in
                    if progress == 1 {
//                        do {
//                            let processor = BookProcessor(id: id, url: bookFile, filesService: self.filesService)
//                            try processor.process()
//                        } catch {
//                            observable.onError(error)
//                        }
                        observable.onNext(progress)
                        _ = self.filesService.removeBookZip(id: id)
                    } else {
                        observable.onNext(progress*0.9)
                    }
                }, fileOutputHandler: nil)
            } catch {
                observable.onError(error)
            }
            return Disposables.create()
        }
    }

    func getBook(id: Int) -> Single<Book> {
        let url = filesService.getBookFileUrl(id: id)
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let book = try Book(data: data)
            return Single.just(book)
        } catch {
            return Single.error(error)
        }
    }

    func remove(id: Int) -> Bool {
        return filesService.removeBook(id: id)
    }

    func bookFilesExists(id: Int) -> Bool {
        return filesService.bookFilesExists(id: id)
    }
}
