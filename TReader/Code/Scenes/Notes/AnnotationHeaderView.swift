//
//  AnnotationHeaderView.swift
//  TReader
//
//  Created by tadas on 2020-05-28.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AnnotationHeaderView: UIStackView {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchContainer: UIView!
    @IBOutlet var defaultBar: UIView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var sortButton: UIButton!

    override func awakeFromNib() {
        showSearchBar(false)

        searchButton.rx
            .tap
            .asDriver()
            .map { _ in true }
            .drive(onNext: showSearchBar)
            .disposed(by: rx.disposeBag)

        searchBar.rx
            .cancelButtonClicked
            .asDriver().map { _ in false }
            .drive(onNext: showSearchBar)
            .disposed(by: rx.disposeBag)
    }

    func showSearchBar(_ show: Bool) {
        searchContainer.isHidden = !show
        defaultBar.isHidden = show
        updateHeigh()

        if show {
            searchBar.becomeFirstResponder()
        }
    }

    func updateHeigh() {
        frame.size.height = defaultBar.isHidden ? 48 : 38
        guard let table = superview as? UITableView else { return }
        table.tableHeaderView = self
    }
}
