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
        let canEdit = BehaviorSubject<Bool>(value: false)
        let onRemove = toolbar.removeButton.rx.tap
            .flatMap { [unowned self] _ in self.canRemove() }
            .filter { $0 }
            .asDriverOnErrorJustComplete()
            .mapToVoid()
        let itemSelected = collectionView.rx.itemSelected.asDriver().map { $0.row }

        let input = BooksListViewModel.Input(onSelect: itemSelected,
                                             canEdit: canEdit.asDriver(onErrorJustReturn: false),
                                             onRemove: onRemove)
        let output = viewModel.transform(input: input)

        let cellIdentifier = BooksListItemCell.reuseIdentifier
        let cellType = BooksListItemCell.self

        output.books
            .asObservable()
            .bind(to: collectionView.rx
                .items(cellIdentifier: cellIdentifier, cellType: cellType)) { _, model, cell in
                    cell.set(viewModel: model)
        }
        .disposed(by: rx.disposeBag)

        output.drivers.forEach {
            $0.drive().disposed(by: rx.disposeBag)
        }

        output.canRemove
            .drive(onNext: { [unowned self] in self.toolbar.set(state: $0 ? .enabled : .disabled) })
            .disposed(by: rx.disposeBag)

        output.remove
            .drive(onNext: { [unowned self] indexes in
                let paths = indexes.map { IndexPath(row: $0, section: 0) }
                self.collectionView.reloadItems(at: paths)
                self.edit()
                canEdit.onNext(false)
            })
            .disposed(by: rx.disposeBag)

        editButton.rx.tap
            .do(onNext: { [unowned self] _ in
                canEdit.onNext(!self.tabBarController!.tabBar.isHidden)
            })
            .bind(onNext: edit)
            .disposed(by: rx.disposeBag)
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

    func canRemove() -> Single<Bool> {
        return Single.create { single in
            let alert = UIAlertController(title: nil, message: "Remove the download.", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Remove download", style: .default) { _ in
                single(.success(true))
            })
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                single(.success(false))
            })
            self.present(alert, animated: true, completion: nil)
            return Disposables.create()
        }
        .observeOn(MainScheduler.instance)
    }
}
