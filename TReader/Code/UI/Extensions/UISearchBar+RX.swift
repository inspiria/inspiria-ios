//
//  UISearchBar+RX.swift
//  TReader
//
//  Created by tadas on 2020-05-28.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UISearchBar {
    //fixing bug https://github.com/ReactiveX/RxSwift/issues/1714#issuecomment-427669134
    var textChanged: Observable<String> {
        return Observable.of(textDidEndEditing.map { "" }, text.orEmpty.asObservable())
            .merge()
            .distinctUntilChanged()
    }
}
