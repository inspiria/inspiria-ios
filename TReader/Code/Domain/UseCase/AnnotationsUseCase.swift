//
//  AnnotationsUseCase.swift
//  TReader
//
//  Created by tadas on 2020-06-12.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum AnnotationsError: LocalizedError {
    case noUserProfile

    var errorDescription: String? {
        switch self {
        case .noUserProfile: return "Failed to restore user profile. Please login with Hypothesis."
        }
    }
}

protocol AnnotationsUseCase {
    var userProfile: Driver<UserProfile?> { get }

    func getUserProfile() -> Single<UserProfile>
    func getAnnotations(shortName: String?, quote: String?) -> Single<[Annotation]>
    func deleteAnnotation(id: String) -> Single<Bool>
    func updateAnnotation(update: AnnotationUpdate) -> Single<Annotation>
    func createAnnotation(create: AnnotationCreate) -> Single<Annotation>
}

class HypothesisAnnotationsUseCase: AnnotationsUseCase {
    private let networkService: NetworkService
    fileprivate lazy var userProfileRelay = BehaviorRelay<UserProfile?>(value: latestUserProfile())

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getUserProfile() -> Single<UserProfile> {
        return networkService
            .request(path: "profile", method: .get)
            .do(onSuccess: set(userProfile:), onError: deleteUserProfile)
    }

    func getAnnotations(shortName: String?, quote: String?) -> Single<[Annotation]> {
        guard let userId = userProfileRelay.value?.userId else { return Single.error(AnnotationsError.noUserProfile) }
        let shortName = shortName.flatMap { "\($0)/*" } ?? "*"
        let wildcardUri = "https://edtechbooks.org/\(shortName)"
        let data = AnnotationSearch(limit: 200,
                                    user: userId,
                                    quote: quote,
                                    wildcardUri: wildcardUri)

        let response: Single<AnnotationResponse> = networkService.request(path: "search", method: .get, data: data)
        return response
            .map { $0.rows }
    }

    func updateAnnotation(update: AnnotationUpdate) -> Single<Annotation> {
        return networkService.request(path: "annotations/\(update.id)", method: .patch, data: update)
    }

    func createAnnotation(create: AnnotationCreate) -> Single<Annotation> {
        return networkService.request(path: "annotations", method: .post, data: create)
    }

    func deleteAnnotation(id: String) -> Single<Bool> {
        let response: Single<DeleteAnnotationResponse> = networkService.request(path: "annotations/\(id)", method: .delete)
        return response.map { $0.deleted }
    }
}

extension HypothesisAnnotationsUseCase {
    private static let kUserProfileDataKey = "user-profile-data-key"
    var userProfile: Driver<UserProfile?> { userProfileRelay.asDriver() }

    fileprivate func latestUserProfile() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: HypothesisAnnotationsUseCase.kUserProfileDataKey) else { return nil }
        return try? UserProfile(data: data)
    }

    fileprivate func deleteUserProfile(error: Error) {
        print("failed to get user: \(error)")
        self.set(userProfile: nil)
    }

    fileprivate func set(userProfile: UserProfile?) {
        userProfileRelay.accept(userProfile)
        let data = userProfile?.jsonDataOrNil()
        UserDefaults.standard.set(data, forKey: HypothesisAnnotationsUseCase.kUserProfileDataKey)
        UserDefaults.standard.synchronize()
    }
}
