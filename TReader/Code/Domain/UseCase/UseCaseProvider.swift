//
//  UseCaseProvider.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

protocol UseCaseProvider {
    func booksUseCase() -> BooksUseCase
}

class DefaultUseCaseProvider: UseCaseProvider {
    static var provider = DefaultUseCaseProvider()

    private  let mNetworkService: NetworkService

    init() {
        mNetworkService = NetworkService(url: "http://172.20.10.3:8080")
    }

    func booksUseCase() -> BooksUseCase {
        return DefaultBooksUseCase(networkService: mNetworkService,
                                   bookStorage: DefaultBooksStorage(userDefaults: UserDefaults.standard,
                                                                    fileManager: FileManager.default))
    }
}
