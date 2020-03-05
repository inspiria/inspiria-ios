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
        let url: String
        #if DEBUG
            url = "http://localisation:8080"
        #else
            url = "http://3.127.45.134:8080"
        #endif
        mNetworkService = NetworkService(url: url)
    }

    func booksUseCase() -> BooksUseCase {
        return DefaultBooksUseCase(networkService: mNetworkService,
                                   bookStorage: DefaultBooksStorage(userDefaults: UserDefaults.standard,
                                                                    fileManager: FileManager.default))
    }
}
