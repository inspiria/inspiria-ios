//
//  ChapterViewController.swift
//  TReader
//
//  Created by tadas on 2020-03-05.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChapterViewController: UIViewController {
    var viewModel: ChapterViewModel!

    private let textView = TRTextView()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
        view.addSubview(textView)

        textView.isEditable = false
        textView.backgroundColor = .clear
        textView.tintColor = ColorStyle.orange.color
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let input = ChapterViewModel.Input()
        let output = viewModel.transform(input: input)

        Driver.combineLatest(viewWillAppear, output.chapter) { $1 }
            .drive(onNext: { [unowned self] chapter in
                self.parent?.navigationItem.title = chapter.title
                self.textView.setBookId(id: chapter.bookId)
                self.textView.setHTML(chapter.text)
            })
            .disposed(by: rx.disposeBag)
    }
}
