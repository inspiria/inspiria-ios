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

        tableView.backgroundColor = ColorStyle.iconsLight.color
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        tableView.register(AnnotationCell.nib(), forCellReuseIdentifier: AnnotationCell.reuseIdentifier)
    }

    private func bindViewModel() {

        navigationItem
            .leftBarButtonItem?.rx.tap
            .asDriver()
            .map { (true, nil) }
            .drive(onNext: dismiss)
            .disposed(by: rx.disposeBag)

        let output = viewModel.transform()
        let cellIdentifier = AnnotationCell.reuseIdentifier
        let cellType = AnnotationCell.self

        output.annotations
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)) { [unowned self] _, model, cell in
                cell.set(model: model)
                self.tableView.refreshControl?.endRefreshing()
        }
        .disposed(by: rx.disposeBag)

        output.cancel
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
