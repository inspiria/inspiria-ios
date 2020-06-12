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
    func bookmarkUseCase() -> BookmarkUseCase
    func hypothesisUseCase() -> HypothesisUseCase
}

class DefaultUseCaseProvider: UseCaseProvider {
    static var provider = DefaultUseCaseProvider()
    private let mNetworkService: NetworkService
    private let mHypothesisNetworkService: NetworkService
    private let mCoreDataContext = CoreDataContext()

    init() {
        let url: String
        let auth = HypothesisAuthorization()
        auth.logIn(token: "6879-9ufmPdyfHY9OKOjP3nYoPpfx8AdKPwDG5YseyoDNGIg")

        #if DEBUG
            url = "http://127.0.0.1:8080"
        #else
            url = "http://18.197.153.150:8080"
        #endif
        mNetworkService = NetworkService(url: url)
        mHypothesisNetworkService = NetworkService(url: "https://hypothes.is/api", authorization: auth)
    }

    func booksUseCase() -> BooksUseCase {
        return DefaultBooksUseCase(networkService: mNetworkService,
                                   bookStorage: DefaultBooksStorage(userDefaults: UserDefaults.standard,
                                                                    filesService: DefaultBookFilesService(manager: FileManager.default)))
    }

    func bookmarkUseCase() -> BookmarkUseCase {
        return DefaultBookmarkUseCase(managedObjectContext: mCoreDataContext.managedObjectContext)
    }

    func hypothesisUseCase() -> HypothesisUseCase {
        return DefaultHypothesisUseCase(networkService: mHypothesisNetworkService)
    }
}
