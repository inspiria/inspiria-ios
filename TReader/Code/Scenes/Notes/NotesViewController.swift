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

class NotesViewController: UITableViewController {
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
        let output = viewModel.transform(input: input)
        output.disposableDrivers.forEach { $0.drive().disposed(by: rx.disposeBag) }
    }
}
