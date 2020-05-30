//
//  BookmarksViewController.swift
//  TReader
//
//  Created by tadas on 2020-05-30.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookmarksViewController: UITableViewController {
    var viewModel: BookmarksViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
        tableView.dataSource = nil
        tableView.delegate = nil
        tableView.tableFooterView = UIView()
    }

    private func bindViewModel() {
        let input = BookmarksViewModel.Input()
        let output = viewModel.transform(input: input)
        let cellIdentifier = BookmarksTableViewCell.reuseIdentifier
        let cellType = BookmarksTableViewCell.self

        output.bookmarks
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)) { _, model, cell in
                cell.set(model: model)
            }
            .disposed(by: rx.disposeBag)
    }
}
