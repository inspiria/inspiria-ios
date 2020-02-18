//
//  BookViewController.swift
//  TReader
//
//  Created by tadas on 2020-02-16.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BookViewController: UITableViewController {
    var viewModel: BookViewModel!

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
        let input = BookViewModel.Input()
        let output = viewModel.transform(input: input)

        output.book
            .map { $0.chapters }
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, model, cell) in
                let number = model.showNumber == 1 ? "\(Int(floor(model.order)))." : " "
                cell.textLabel?.text = "\(number) \(model.title)"
        }
        .disposed(by: rx.disposeBag)
    }
}
