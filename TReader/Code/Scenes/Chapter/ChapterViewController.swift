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
import SwiftSoup

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
            .asObservable()
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .map { $0.text.processImagesTag(bookId: $0.bookId) }
            .map { $0.htmlAttributedString }
            .asDriverOnErrorJustComplete()
            .drive(textView.rx.attributedText)
            .disposed(by: rx.disposeBag)

        output.chapter
            .map { $0.title }
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
    }
}

private extension String {
    func processImagesTag(bookId: Int) -> String {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("\(bookId)", isDirectory: true).absoluteString

        do {
            let doc: Document = try SwiftSoup.parse(self)
            let img = try doc.select("img")
            let res: [()] = try img.map { elem in
                try elem.attr("src", path + (elem.getAttributes()?.get(key: "src") ?? ""))
                try elem.attr("width", "\(UIScreen.main.bounds.width - 24)")
            }
            print(res)
            let result = try doc.html()
            return result
        } catch {
            print(error)
            return self
        }
    }
}
