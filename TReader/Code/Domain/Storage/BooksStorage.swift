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
    func delete(id: Int) -> Single<Bool>
}

class DefaultBooksStorage: BooksStorage {
    private let defaults: UserDefaults
    private let manager: FileManager

    init(userDefaults: UserDefaults, fileManager: FileManager) {
        self.defaults = userDefaults
        self.manager = fileManager
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

    func bookFilesExists(id: Int) -> Bool {
        do {
            let path = getBookFileUrl(id: id)
            return try path.checkResourceIsReachable()
        } catch {
            return false
        }
    }

    func storeBook(id: Int, data: Data) -> Observable<Double> {
        let bookUrl = getBookUrl(id: id)
        let zipUrl = bookUrl.appendingPathExtension(".zip")
        do {
            try data.write(to: zipUrl)
        } catch {
            return Observable.error(error)
        }
        return Observable.create { observable in
            do {
                try Zip.unzipFile(zipUrl,
                                  destination: bookUrl,
                                  overwrite: true,
                                  password: nil,
                                  progress: { progress in
                                    observable.onNext(progress)
                },
                                  fileOutputHandler: { [unowned self] _ in
                                    do {
                                        try self.manager.removeItem(at: zipUrl)
                                    } catch {}
                })
            } catch {
                observable.onError(error)
            }
            return Disposables.create()
        }
    }

    func getBook(id: Int) -> Single<Book> {
        let url = getBookFileUrl(id: id)
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let book = try Book(data: data)
            return Single.just(book)
        } catch {
            return Single.error(error)
        }
    }

    func delete(id: Int) -> Single<Bool> {
        let url = getBookUrl(id: id)
        do {
            try self.manager.removeItem(at: url)
            return Single.just(true)
        } catch {
            return Single.error(error)
        }
    }
}

private extension DefaultBooksStorage {
    func getBookUrl(id: Int) -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("\(id)", isDirectory: true)
        return path
    }

    func getBookFileUrl(id: Int) -> URL {
        return getBookUrl(id: id).appendingPathComponent("book.json")
    }
}
