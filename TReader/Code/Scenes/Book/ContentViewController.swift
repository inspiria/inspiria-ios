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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        bindViewModel()
    }
    
    func configureView() {
    }
    
    private func bindViewModel() {
        let select = BehaviorSubject<Int>(value: 0)
        let input = ContentViewModel.Input(onSelect: select.asDriverOnErrorJustComplete().skip(1))
        let output = viewModel.transform(input: input)

        output.info
            .drive(onNext: { [unowned self] info in
                self.navigationItem.title = info.title

                let header = ContentHeaderView(title: info.title,
                                               author: "Author unknown",
                                               coverUrl: info.coverImageUrl)

                self.stackView.addArrangedSubview(header)
            })
            .disposed(by: rx.disposeBag)

        output.chapters
            .drive(onNext: { chapters in
                chapters.enumerated().forEach { [unowned self] arg in
                    let model = arg.element
                    let number = model.showNumber == 1 ? " \(Int(floor(model.order)))." : " ·"
                    let text = "\(number) \(model.title)"
                    let label = UILabel()
                    label.text = text
                    label.numberOfLines = 0
                    label.font = .systemFont(ofSize: 14)

                    label.rx.tapGesture()
                        .asDriver()
                        .map { _ in arg.offset }
                        .drive(select)
                        .disposed(by: self.rx.disposeBag)
                    self.stackView.addArrangedSubview(label)
                }
            })
            .disposed(by: rx.disposeBag)
        
        output.open
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
