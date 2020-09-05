//
//  AnnotationCell.swift
//  TReader
//
//  Created by tadas on 2020-05-27.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import DTRichTextEditor

struct AnnotationCellModel {
    fileprivate var deletePS = PublishSubject<String>()
    fileprivate var editPS = PublishSubject<Annotation>()
    var delete: Driver<String> { return deletePS.asDriverOnErrorJustComplete() }
    var edit: Driver<Annotation> { return editPS.asDriverOnErrorJustComplete() }

    let annotation: Annotation
    let highlight: String?

    init(annotation: Annotation, highlight: String? = nil) {
        self.annotation = annotation
        self.highlight = highlight
    }
}

class AnnotationCell: UITableViewCell {

    @IBOutlet var containerView: UIView!

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var chapterLabel: UILabel!
    @IBOutlet var pageLabel: UILabel!
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var userTextLabel: DTAttributedLabel!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!

    private var disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        let cornerRadius: CGFloat = 3.0
        containerView.backgroundColor = .white
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.25
        containerView.layer.shadowOffset = CGSize(width: 0.0, height: 1.5)
        containerView.layer.shadowRadius = 2
        containerView.layer.cornerRadius = cornerRadius
    }

    func set(model: AnnotationCellModel) {
        dateLabel.text = model.annotation.updated.formatedString()

        if let str = model.highlight, !str.isEmpty {
            let strings = str.components(separatedBy: " ")
            quoteLabel.attributedText = model.annotation.quote.highlight(text: strings, color: ColorStyle.orange.color)
            userTextLabel.attributedString = model.annotation.text.highlight(text: strings, color: ColorStyle.orange.color)
        } else {
            quoteLabel.text = model.annotation.quote
            userTextLabel.attributedString = model.annotation.text.highlight(text: [])
        }

        disposeBag = DisposeBag()
        editButton.rx
            .tap
            .asDriver()
            .map { model.annotation }
            .drive(model.editPS)
            .disposed(by: disposeBag)

        deleteButton.rx
            .tap
            .asDriver()
            .map { model.annotation.id }
            .drive(model.deletePS)
            .disposed(by: disposeBag)
    }
}

extension String {
    func highlight(text: [String], color: UIColor? = nil, font: UIFont? = nil) -> NSAttributedString? {
        let matches: [NSTextCheckingResult] = text.flatMap { text -> [NSTextCheckingResult] in
            guard let regex = try? NSRegularExpression(pattern: text, options: .caseInsensitive) else { return [] }
            let range = NSRange(location: 0, length: self.utf16.count)
            return regex.matches(in: self, options: [], range: range)
        }

        let string = NSMutableAttributedString(string: self)
        matches.forEach {
            if let color = color {
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: $0.range)
            }
            if let font = font {
                string.addAttribute(NSAttributedString.Key.font, value: font, range: $0.range)
            }
        }
        return string
    }
}
