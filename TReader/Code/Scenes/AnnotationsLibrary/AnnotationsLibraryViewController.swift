//
//  AnnotationsLibraryViewController.swift
//  TReader
//
//  Created by tadas on 2020-09-04.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AnnotationsLibraryViewController: UITableViewController {
    var viewModel: AnnotationsLibraryViewModel!

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

        Driver.just([CellModel]())
            .map { TableDataSourceState.cells($0).sections }
            .drive(tableView.rx.items(dataSource: TableDataSource()))
            .disposed(by: rx.disposeBag)

        let input = AnnotationsLibraryViewModel.Input()
        let output = viewModel.transform(input: input)
        output.disposableDrivers.forEach { $0.drive().disposed(by: rx.disposeBag) }
    }
}
