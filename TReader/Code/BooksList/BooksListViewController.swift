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

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = nil
        collectionView.dataSource = nil

        let books = Observable.just([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11])
        let cellIdentifier = BooksListItemCell.reuseIdentifier
        let cellType = BooksListItemCell.self

        books.bind(to: collectionView.rx
            .items(cellIdentifier: cellIdentifier, cellType: cellType)) { _, index, cell in cell.set(index: index) }
        .disposed(by: rx.disposeBag)
    }
}

