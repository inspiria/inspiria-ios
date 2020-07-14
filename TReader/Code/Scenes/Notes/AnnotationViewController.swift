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

    @IBOutlet var headerView: AnnotationHeaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
        tableView.dataSource = nil
        tableView.delegate = nil

        tableView.refreshControl = UIRefreshControl()
    }

    private func bindViewModel() {
        let search = headerView.searchBar
            .rx.textChanged
            .map { $0.count > 0 ? $0 : nil }
            .asDriver(onErrorJustReturn: nil)
            .debounce(0.5)

        let refresh = tableView.refreshControl!
            .rx.controlEvent(.valueChanged)
            .asDriver()
            .startWith(())

        let sort = headerView.sortButton
            .rx.tap
            .asDriver()
            .flatMap { [unowned self] _ -> Driver<SortView.Order> in
                let x = self.headerView.sortButton.center.x
                let y = self.headerView.sortButton.frame.maxY
                let point = self.headerView.convert(CGPoint(x: x, y: y), to: self.view)
                return SortView.show(in: self.view, at: point)
        }.startWith(.newest)

        let input = AnnotationViewModel.Input(searchTrigger: search,
                                              sortTrigger: sort,
                                              refreshTrigger: refresh)
        let output = viewModel.transform(input: input)
        let cellIdentifier = AnnotationCell.reuseIdentifier
        let cellType = AnnotationCell.self

        output.annotations
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier, cellType: cellType)) { [unowned self] _, model, cell in
                cell.set(model: model)
                self.tableView.refreshControl?.endRefreshing()
        }
        .disposed(by: rx.disposeBag)

        output.deletions
            .drive(onNext: { [unowned self] in $0.forEach { $0.drive().disposed(by: self.rx.disposeBag)}})
            .disposed(by: rx.disposeBag)
        output.edits
            .drive(onNext: { [unowned self] in $0.forEach { $0.drive().disposed(by: self.rx.disposeBag)}})
            .disposed(by: rx.disposeBag)
    }
}
