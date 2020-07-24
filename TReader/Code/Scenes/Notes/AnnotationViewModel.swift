//
//  AnnotationViewModel.swift
//  TReader
//
//  Created by tadas on 2020-05-26.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AnnotationViewModel {
    let navigator: AnnotationNavigator

    init (navigator: AnnotationNavigator) {
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
//        let data = Driver.just([
//            Annotation(date: Date(), quote: "Felis piece gravida nisi, adipiscing risus cras gravida. Id nisl nullam ut commodo", text: nil),
//            Annotation(date: Date().addingTimeInterval(-108000),
//                       quote: "Habitant integer proin sit velit, in in turpis. Ut fermentum urna sed est posuere vel.",
//                       text: "Here is the note about the piece of text above that I highlighted on the page. Here is my opinion. "),
//            Annotation(date: Date().addingTimeInterval(-300000),
//                       quote: "Pretium nibh ornare orci element pretium ornare. Pellente auctor  enim, neque sit non, elit. In sed sit.",
//                       text: "Group, what do you think? "),
//            Annotation(date: Date().addingTimeInterval(-500000),
//                       quote: "Convallis tincidunt arcu, posuere platea. Ut sit at nulla vitae. Nibh vulputate ante tellus facilisis lorem quisque.", text: nil),
//            Annotation(date: Date().addingTimeInterval(-2000000),
//                       quote: "Tincidunt arcu, posuere platea. Ut sit at nulla vitae. Nibh ante tellus facilisis lorem quisque vulputate. ",
//                       text: "I agree with the above plus this")
//        ])
        let data = Driver<[Annotation]>.just([])

        let annotations = Driver<[Annotation]>
            .combineLatest(data, input.searchTrigger, input.sortTrigger) { data, str, order in
                return data.filter(by: str).sorted(by: order)
        }

        return Output(annotations: annotations)
    }
}

extension AnnotationViewModel {
    struct Input {
        let searchTrigger: Driver<String>
        let sortTrigger: Driver<SortView.Order>
    }
    struct Output {
        let annotations: Driver<[Annotation]>
    }
}

struct Annotation {
    let date: Date
    let quote: String
    let text: String?
}

extension Array where Element == Annotation {
    func filter(by str: String) -> Self {
        if str.isEmpty { return self }
        let str = str.lowercased()
        return filter { $0.quote.lowercased().contains(str) || ($0.text?.lowercased().contains(str) ?? false)}
    }

    func sorted(by order: SortView.Order) -> Self {
        switch order {
        case .newest: return sorted { $0.date > $1.date }
        case .oldest: return sorted { $0.date < $1.date }
        case .ascending: return sorted { $0.quote < $1.quote }
        case .descending: return sorted { $0.quote > $1.quote }
        }
    }
}
