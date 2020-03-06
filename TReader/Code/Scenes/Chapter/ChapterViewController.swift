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

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
    }

    private func bindViewModel() {
        let input = ChapterViewModel.Input()
        let output = viewModel.transform(input: input)

        output.chapter
            .map { $0.textProcessed.att() }
            .drive(textView.rx.attributedText)
            .disposed(by: rx.disposeBag)

        output.chapter
            .map { $0.title }
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
    }
}

extension String {
    func att() -> NSAttributedString? {
        let string = self.data(using: .unicode) ?? Data()
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        return try? NSAttributedString(data: string, options: options, documentAttributes: nil)
    }
}
