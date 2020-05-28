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

struct Annotation {
    let date: Date
    let quote: String
    let text: String?
}

class AnnotationViewModel {
    let navigator: AnnotationNavigator

    init (navigator: AnnotationNavigator) {
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {
        let data = Driver.just([
            Annotation(date: Date(), quote: "Felis piece gravida nisi, adipiscing risus cras gravida. Id nisl nullam ut commodo", text: nil),
            Annotation(date: Date().addingTimeInterval(-108000),
                       quote: "Habitant integer proin sit velit, in in turpis. Ut fermentum urna sed est posuere vel.",
                       text: "Here is the note about the piece of text above that I highlighted on the page. Here is my opinion. "),
            Annotation(date: Date().addingTimeInterval(-300000),
                       quote: "Pretium nibh ornare orci element pretium ornare. Pellente auctor  enim, neque sit non, elit. In sed sit.",
                       text: "Group, what do you think? "),
            Annotation(date: Date().addingTimeInterval(-500000),
                       quote: "Convallis tincidunt arcu, posuere platea. Ut sit at nulla vitae. Nibh vulputate ante tellus facilisis lorem quisque.", text: nil),
            Annotation(date: Date().addingTimeInterval(-2000000),
                       quote: "Tincidunt arcu, posuere platea. Ut sit at nulla vitae. Nibh ante tellus facilisis lorem quisque vulputate. ",
                       text: "I agree with the above plus this")
        ])

        let annotations = Driver<[Annotation]>
            .combineLatest(data, input.searchTrigger) { data, str in
            if str.isEmpty { return data }
                return data.filter { $0.quote.lowercased().contains(str.lowercased()) || ($0.text?.lowercased().contains(str.lowercased()) ?? false) }
        }

        return Output(annotations: annotations)
    }
}

extension AnnotationViewModel {
    struct Input {
        let searchTrigger: Driver<String>
    }
    struct Output {
        let annotations: Driver<[Annotation]>
    }
}
