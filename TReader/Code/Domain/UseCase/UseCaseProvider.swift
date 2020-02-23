//
//  UseCaseProvider.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

protocol UseCaseProvider {
    func booksListUseCase() -> BooksListUseCase
    func bookUseCase() -> BookUseCase
}

class DefaultUseCaseProvider: UseCaseProvider {
    static var provider = DefaultUseCaseProvider()

    private  let mNetworkService: NetworkService

    init() {
        mNetworkService = NetworkService(url: "http://10.0.1.105:3000")
    }

    func booksListUseCase() -> BooksListUseCase {
        return DefaultBooksListUseCase(networkService: mNetworkService)
    }

    func bookUseCase() -> BookUseCase {
        return DefaultBookUseCase(networkService: mNetworkService)
    }

}
