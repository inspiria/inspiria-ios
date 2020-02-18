//
//  BookUseCase.swift
//  TReader
//
//  Created by tadas on 2020-02-18.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Zip

protocol BookUseCase {
    func bookExists(id: Int) -> Bool
    func downloadBook(id: Int) -> Observable<Double>
    func book(id: Int) -> Single<Book>
}

class DefaultBookUseCase: BookUseCase {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func bookExists(id: Int) -> Bool {
        let path = getBookFileUrl(id: id).path
        return FileManager.default.fileExists(atPath: path)
    }

    func downloadBook(id: Int) -> Observable<Double> {
        return networkService.fileRequest(path: "book/\(id)")
            .do(onNext: { [unowned self] download in
                if download.progress == 1.0 {
                    guard let data = download.data else { return }
                    self.storeBook(id: id, data: data)
                }
            })
            .map { $0.progress }
    }

    func book(id: Int) -> Single<Book> {
        let url = getBookFileUrl(id: id)
        do {
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            let book = try Book(data: data)
            return Single.just(book)
        } catch {
            print("Load Failed: \(error)")
            return Single.error(error)
        }
    }
}

private extension DefaultBookUseCase {
    func getBookUrl(id: Int) -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("\(id)", isDirectory: true)
        return path
    }

    func getBookFileUrl(id: Int) -> URL {
        return getBookUrl(id: id).appendingPathComponent("book.json")
    }

    func storeBook(id: Int, data: Data) {
        let bookPath = getBookUrl(id: id)
        let zipPath = bookPath.appendingPathExtension(".zip")
        do {
            try data.write(to: zipPath)
            try Zip.unzipFile(zipPath,
                              destination: bookPath,
                              overwrite: true,
                              password: nil,
                              progress: { progress in
                                print(progress)
            })
        } catch {
            print("Error: \(error)")
        }

    }
}
