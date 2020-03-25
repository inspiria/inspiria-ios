//
//  ContentViewController.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContentViewController: UIViewController {
    @IBOutlet weak var stackView: UIStackView!

    var viewModel: ContentViewModel!
    
    private let select = BehaviorSubject<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindViewModel()
    }
    
    func configureView() {
    }
    
    private func bindViewModel() {
        let input = ContentViewModel.Input(onSelect: select.asDriverOnErrorJustComplete().skip(1))
        let output = viewModel.transform(input: input)

        output.info
            .drive(onNext: { [unowned self] info in
                self.navigationItem.title = info.title
                let header = ContentHeaderView(title: info.title,
                                               author: info.author,
                                               coverUrl: info.coverImageUrl)
                self.stackView.addArrangedSubview(header)
            })
            .disposed(by: rx.disposeBag)

        output.chapters
            .drive(onNext: { [unowned self] chapters in
                chapters.enumerated().forEach { arg in
                    let label = self.buildLabel(for: arg.element, offset: arg.offset)
                    self.stackView.addArrangedSubview(label)
                    if chapters.count - 1 == arg.offset {
                        self.stackView.setCustomSpacing(20, after: label)
                    }
                }
            })
            .disposed(by: rx.disposeBag)
        
        output.authors
            .drive(onNext: { [unowned self] authors in
                authors.forEach { author in
                    let view = AuthorSectionView(name: author.name,
                                                 text: author.bio,
                                                 photoUrl: author.pictureUrl)
                    self.stackView.addArrangedSubview(view)
                    self.stackView.setCustomSpacing(20, after: view)
                }
            })
            .disposed(by: rx.disposeBag)
        
        output.open
            .drive()
            .disposed(by: rx.disposeBag)
    }
    
    func buildLabel(for model: Chapter, offset: Int) -> UIView {
        let number = model.showNumber ? "\(Int(floor(model.orderNumber))). " : ""
        let text = "\(number)\(model.title)"
        
        let label = Label()
        label.textStyle = model.showHeadings ? TextStyle.Book.bodyText : TextStyle.Book.h4
        label.headIndent = model.showHeadings ? 34 : 18
        label.text = text
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)

        label.rx.tapGesture()
            .asDriver()
            .map { _ in offset }
            .drive(select)
            .disposed(by: rx.disposeBag)
        
        return label
    }
}
