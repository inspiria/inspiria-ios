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

    private var editButton: UIBarButtonItem!
    private var toolbar: BooksListToolbar!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
        collectionView.delegate = nil
        collectionView.dataSource = nil

        editButton = UIBarButtonItem(title: "Edit", style: .done, target: nil, action: nil)
        navigationItem.rightBarButtonItem = editButton

        guard let h = tabBarController?.tabBar.frame.height else { return }
        let bounds = UIScreen.main.bounds
        let frame = CGRect(x: 0, y: bounds.height - h, width: bounds.width, height: h)
        toolbar = BooksListToolbar(frame: frame)
        view.addSubview(toolbar)
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

        output.fetch
            .drive()
            .disposed(by: rx.disposeBag)

        editButton.rx.tap.bind { [unowned self] _ in
            self.edit()
            self.collectionView.reloadData()
        }.disposed(by: rx.disposeBag)
    }
}

private extension BooksListViewController {
    func edit() {
        if tabBarController!.tabBar.isHidden {
            tabBarController?.tabBar.isHidden = false
            toolbar.set(state: .hidden)
            editButton.tintColor = ColorStyle.bkgrndWhite.color
            editButton.title = "Edit"
        } else {
            tabBarController?.tabBar.isHidden = true
            toolbar.set(state: .disabled)
            editButton.tintColor = ColorStyle.orange.color
            editButton.title = "Done"
        }
    }
}

