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
        let select = tableView.rx.itemSelected.asDriver().map { $0.row }
        let input = BookViewModel.Input(onSelect: select)
        let output = viewModel.transform(input: input)
        
        output.chapters
            .asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, model, cell) in
                let number = model.showNumber == 1 ? "\(Int(floor(model.order)))." : " "
                cell.textLabel?.text = "\(number) \(model.title)"
        }
        .disposed(by: rx.disposeBag)
        
        output.info
            .map { $0.title }
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        output.open
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
