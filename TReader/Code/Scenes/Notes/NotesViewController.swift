//
//  NotesViewController.swift
//  TReader
//
//  Created by tadas on 2020-05-26.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AnnotationViewController: UITableViewController {
    var viewModel: NotesViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
        tableView.dataSource = nil
        tableView.delegate = nil
    }

    private func bindViewModel() {
        let input = NotesViewModel.Input()

        let cellIdentifier = NotesTableViewCell.reuseIdentifier
        let cellType = NotesTableViewCell.self

        Observable.just(["1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3", "1", "2", "3"])
            .bind(to: tableView.rx
                .items(cellIdentifier: cellIdentifier, cellType: cellType)) { _, model, cell in
                    cell.set(viewModel: model)
        }.disposed(by: rx.disposeBag)

        let output = viewModel.transform(input: input)
        output.disposableDrivers.forEach { $0.drive().disposed(by: rx.disposeBag) }
    }
}
