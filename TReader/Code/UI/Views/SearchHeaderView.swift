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

class SearchHeaderView: UIStackView, NibLoadable {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var searchContainer: UIView!
    @IBOutlet var defaultBar: UIView!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var sortButton: UIButton!

    class func view() -> SearchHeaderView {
        return SearchHeaderView.fromNib()
    }

    override func awakeFromNib() {
        showSearchBar(false)

        AppAppearance.setupSearchBarAppearance(searchBar: searchBar)

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
        } else {
            searchBar.text = nil
            searchBar.resignFirstResponder()
        }
    }

    func updateHeigh() {
        frame.size.height = defaultBar.isHidden ? 48 : 38
        guard let table = superview as? UITableView else { return }
        table.tableHeaderView = self
    }
}
