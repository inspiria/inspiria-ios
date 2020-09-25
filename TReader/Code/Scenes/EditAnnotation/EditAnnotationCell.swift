//
//  EditAnnotationCell.swift
//  TReader
//
//  Created by Mantas on 20/09/2020.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

struct EditAnnotationModel {
    fileprivate var savePS = PublishSubject<String>()
    fileprivate var cancelPS = PublishSubject<Void>()
    var save: Driver<String> { return savePS.asDriverOnErrorJustComplete() }
    var cancel: Driver<Void> { return cancelPS.asDriverOnErrorJustComplete() }
    
    let annotation: Annotationable
    
    init(annotation: Annotationable) {
        self.annotation = annotation
    }
}

class EditAnnotationCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var chapterLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var quoteLabel: UILabel!
    
    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
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
        inputTextView.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    func set(model: EditAnnotationModel) {
        inputTextView.text = model.annotation.text
        inputTextView.becomeFirstResponder()
        
        saveButton.rx
            .tap
            .asDriver()
            .map { [weak self] in self?.inputTextView.text ?? "" }
            .drive(model.savePS)
            .disposed(by: disposeBag)

        cancelButton.rx
            .tap
            .asDriver()
            .drive(model.cancelPS)
            .disposed(by: disposeBag)
    }
    
}
