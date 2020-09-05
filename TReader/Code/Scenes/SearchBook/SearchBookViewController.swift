//
//  SearchBookViewController.swift
//  TReader
//
//  Created by tadas on 2020-09-04.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchBookViewController: UITableViewController {
    var viewModel: SearchBookViewModel!

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var bookTitle: UILabel!

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
        let input = SearchBookViewModel.Input()
        let output = viewModel.transform(input: input)
        output.disposableDrivers.forEach { $0.drive().disposed(by: rx.disposeBag) }

        rx.viewWillAppear
            .subscribe(onNext: showKeyboard(show:))
            .disposed(by: rx.disposeBag)

        searchBar.rx
            .cancelButtonClicked
            .subscribe(onNext: self.dismiss)
            .disposed(by: rx.disposeBag)
    }

    private func dismiss() {
        dismiss(animated: true, completion: nil)
    }

    private func showKeyboard(show: Bool) {
        if show {
            searchBar.becomeFirstResponder()
        }
    }
}
