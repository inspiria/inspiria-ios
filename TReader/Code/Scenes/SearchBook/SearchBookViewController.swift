//
//  SearchBookViewController.swift
//  TReader
//
//  Created by tadas on 2020-09-04.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchBookViewController: UITableViewController {
    var viewModel: SearchBookViewModel!

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var bookTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.tableFooterView = UIView()
        tableView.register(SubtitleCell.nib(), forCellReuseIdentifier: SubtitleCell.reuseIdentifier)

        AppAppearance.setupSearchBarAppearance(searchBar: searchBar)
    }

    private func bindViewModel() {
        let search = searchBar.rx
            .textChanged
            .asDriver(onErrorJustReturn: "")
            .debounce(1)

        let itemSelected = tableView
            .rx.modelSelected(SearchItem.self)
            .asDriverOnErrorJustComplete()

        let input = SearchBookViewModel.Input(searchTrigger: search, itemSelected: itemSelected)
        let output = viewModel.transform(input: input)
        let cellIdentifier = SubtitleCell.reuseIdentifier
        let cellType = SubtitleCell.self

        output.items
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)) { _, model, cell in
                cell.set(model: model)
        }
        .disposed(by: rx.disposeBag)

        output.title
            .drive(bookTitle.rx.text)
            .disposed(by: rx.disposeBag)

        output.selected
            .drive()
            .disposed(by: rx.disposeBag)

        rx.viewWillAppear
            .subscribe(onNext: showKeyboard(show:))
            .disposed(by: rx.disposeBag)

        searchBar.rx
            .cancelButtonClicked
            .subscribe(onNext: self.dismiss)
            .disposed(by: rx.disposeBag)
    }

    private func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    private func showKeyboard(show: Bool) {
        if show {
            searchBar.becomeFirstResponder()
        }
    }
}
