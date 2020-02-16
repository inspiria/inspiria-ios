//
//  Observable.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright © 2020 Scale3C. All rights reserved.
//

//https://github.com/sergdort/CleanArchitectureRxSwift/blob/master/CleanArchitectureRxSwift/Utility/Observable+Ext.swift

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }

}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {

    func catchErrorJustComplete() -> Observable<Element> {
        return catchError { _ in
            return Observable.empty()
        }
    }

    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}
