//
//  ViewController.swift
//  TReader
//
//  Created by tadas on 2020-02-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import NSObject_Rx

class BooksListViewController: UICollectionViewController {

    var viewModel: BooksListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
        collectionView.delegate = nil
        collectionView.dataSource = nil
    }

    private func bindViewModel() {

        let itemSelected = collectionView.rx.itemSelected.asDriver().map { $0.row }
        let input = BooksListViewModel.Input(onSelect: itemSelected)
        let output = viewModel.transform(input: input)

        let cellIdentifier = BooksListItemCell.reuseIdentifier
        let cellType = BooksListItemCell.self

        output.books
            .asObservable()
            .bind(to: collectionView.rx
                .items(cellIdentifier: cellIdentifier, cellType: cellType)) { _, model, cell in
                    cell.set(book: model)
        }
        .disposed(by: rx.disposeBag)

        output.select
            .drive()
            .disposed(by: rx.disposeBag)
    }
}

