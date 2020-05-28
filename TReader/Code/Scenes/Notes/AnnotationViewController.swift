//
//  AnnotationViewController.swift
//  TReader
//
//  Created by tadas on 2020-05-26.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AnnotationViewController: UITableViewController {
    var viewModel: AnnotationViewModel!

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
        let input = AnnotationViewModel.Input()
        let output = viewModel.transform(input: input)
        let cellIdentifier = AnnotationTableViewCell.reuseIdentifier
        let cellType = AnnotationTableViewCell.self

        output.annotations.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)) { _, model, cell in
                cell.set(model: model)
            }.disposed(by: rx.disposeBag)
    }
}
