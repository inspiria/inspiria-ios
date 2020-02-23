//
//  BooksListUseCase.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift

protocol BooksListUseCase {
    func books() -> Single<[BookInfo]>
}

class DefaultBooksListUseCase: BooksListUseCase {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func books() -> Single<[BookInfo]> {
        return networkService.request(path: "books", method: .get)
    }
}
