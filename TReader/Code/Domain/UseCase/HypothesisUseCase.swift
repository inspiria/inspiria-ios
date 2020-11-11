//
//  HypothesisUseCase.swift
//  TReader
//
//  Created by tadas on 2020-06-12.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol AnnotationsUseCase {
    func getUserProfile() -> Single<UserProfile>
    func getAnnotations(shortName: String, quote: String?) -> Single<[Annotation]>
    func deleteAnnotation(id: String) -> Single<Bool>
}

class DefaultHypothesisUseCase: AnnotationsUseCase {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getUserProfile() -> Single<UserProfile> {
        return networkService.request(path: "profile", method: .get)
    }

    func getAnnotations(shortName: String, quote: String?) -> Single<[Annotation]> {
        let data = AnnotationSearch(limit: 200,
                                    user: "acct:tadas@hypothes.is",
                                    quote: quote,
                                    wildcardUri: "https://edtechbooks.org/\(shortName)/*")

        let response: Single<AnnotationResponse> = networkService.request(path: "search", method: .get, data: data)
        return response.map { $0.rows }
    }

    func deleteAnnotation(id: String) -> Single<Bool> {
        let response: Single<DeleteAnnotationResponse> = networkService.request(path: "annotations/\(id)", method: .delete).debug()
        return response.map { $0.deleted }
    }
}
