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
        tableView.register(SubtitleCell.nib(), forCellReuseIdentifier: SubtitleCell.reuseIdentifier)
    }

    private func bindViewModel() {
        let itemSelected = tableView
            .rx.itemSelected
            .map { $0.row }
            .asDriverOnErrorJustComplete()
        let input = BookmarksViewModel.Input(itemSelected: itemSelected)
        let output = viewModel.transform(input: input)
        let cellIdentifier = SubtitleCell.reuseIdentifier
        let cellType = SubtitleCell.self

        output.bookmarks
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)) { _, model, cell in
                cell.set(model: model)
            }
            .disposed(by: rx.disposeBag)

        output.selected
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
