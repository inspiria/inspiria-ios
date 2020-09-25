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

struct AnnotationCellModel {
    fileprivate var deletePS = PublishSubject<String>()
    fileprivate var editPS = PublishSubject<Annotationable>()
    fileprivate var savePS = PublishSubject<String>()
    fileprivate var cancelPS = PublishSubject<Void>()

    var delete: Driver<String> { return deletePS.asDriverOnErrorJustComplete() }
    var edit: Driver<Annotationable> { return editPS.asDriverOnErrorJustComplete() }
    var save: Driver<String> { return savePS.asDriverOnErrorJustComplete() }
    var cancel: Driver<Void> { return cancelPS.asDriverOnErrorJustComplete() }

    let annotation: Annotationable
    let isEditing: Bool
    let highlight: String?

    init(annotation: Annotationable, edit: Bool = false, highlight: String? = nil) {
        self.annotation = annotation
        self.isEditing = edit
        self.highlight = highlight
    }
}

class AnnotationCell: UITableViewCell {

    @IBOutlet var containerView: UIView!

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var chapterLabel: UILabel!
    @IBOutlet var pageLabel: UILabel!
    @IBOutlet var quoteLabel: UILabel!
    @IBOutlet var userTextLabel: UILabel!

    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var textView: UIView!

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

        inputTextView.layer.cornerRadius = cornerRadius
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.borderColor = UIColor(hexString: "#E6E6E6")!.cgColor
        inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        saveButton.layer.cornerRadius = cornerRadius
    }

    func set(model: AnnotationCellModel) {
        dateLabel.text = model.annotation.updated.formatedString()

        if model.isEditing {
            editView.isHidden = false
            textView.isHidden = true
            inputTextView.text = model.annotation.text
        } else {
            editView.isHidden = true
            textView.isHidden = false
            userTextLabel.text = model.annotation.text
        }

        if let str = model.highlight, !str.isEmpty {
            let strings = str.components(separatedBy: " ")
            quoteLabel.attributedText = model.annotation.quoteText.highlight(text: strings, color: ColorStyle.orange.color)
        } else {
            quoteLabel.text = model.annotation.quoteText
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

        cancelButton.rx
            .tap
            .asDriver()
            .drive(model.cancelPS)
            .disposed(by: disposeBag)

        saveButton.rx
            .tap
            .asDriver()
            .map { [weak self] in self?.inputTextView.text }
            .filterNil()
            .drive(model.savePS)
            .disposed(by: disposeBag)

        inputTextView.rx.text
            .asDriver()
            .map { model.annotation.text != $0 && $0 != nil }
            .drive(saveButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
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
