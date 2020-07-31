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
    func annotationsUseCase() -> AnnotationsUseCase
    func authUseCase() -> OAuthUseCase
}

class DefaultUseCaseProvider: UseCaseProvider {
    static var provider = DefaultUseCaseProvider()
    private let mNetworkService: NetworkService
    private let mHypothesisNetworkService: NetworkService
    private let mCoreDataContext = CoreDataContext()
    private let mOAuthUseCase = HypothesisOAuthUseCase(networkService: NetworkService(url: "https://hypothes.is/"))

    init() {
        let url: String
        let auth = HypothesisAuthorization()

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

    func annotationsUseCase() -> AnnotationsUseCase {
        return HypothesisAnnotationsUseCase(networkService: mHypothesisNetworkService)
    }

    func authUseCase() -> OAuthUseCase {
        return mOAuthUseCase
    }
}
