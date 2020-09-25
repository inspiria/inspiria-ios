//
//  EditNoteViewController.swift
//  TReader
//
//  Created by tadas on 2020-07-14.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditAnnotationViewController: UITableViewController {
    var viewModel: EditAnnontationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
        tableView.dataSource = nil
        tableView.delegate = nil

        navigationItem.title = "Notes"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "x"), style: .done, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.view.backgroundColor = .red
        tableView.register(EditAnnotationCell.nib(), forCellReuseIdentifier: EditAnnotationCell.reuseIdentifier)
    }

    private func bindViewModel() {

        let input = EditAnnontationViewModel.Input()
        let output = viewModel.transform(input: input)
        output.disposableDrivers.forEach { $0.drive().disposed(by: rx.disposeBag) }

        navigationItem
            .leftBarButtonItem?.rx.tap
            .asDriver()
            .map { (true, nil) }
            .drive(onNext: dismiss)
            .disposed(by: rx.disposeBag)
        
        let cellIdentifier = EditAnnotationCell.reuseIdentifier
        let cellType = EditAnnotationCell.self

        output.annotations
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)) { [unowned self] _, model, cell in
                cell.set(model: model)
                self.tableView.refreshControl?.endRefreshing()
        }
        .disposed(by: rx.disposeBag)
    }
}
