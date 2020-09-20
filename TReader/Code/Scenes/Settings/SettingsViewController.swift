//
//  SettingsViewController.swift
//  TReader
//
//  Created by tadas on 2020-09-19.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingsViewController: UIViewController {
    var viewModel: SettingsViewModel!

    @IBOutlet var logInButton: UIButton!
    @IBOutlet var logOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
    }

    private func bindViewModel() {
        let logInPressed = logInButton.rx.tap.asDriver().mapToVoid()
        let logOutPressed = logOutButton.rx.tap.asDriver().mapToVoid()

        let input = SettingsViewModel.Input(logInPressed: logInPressed, logOutPressed: logOutPressed)
        let output = viewModel.transform(input: input)

        output.isLoggedIn
            .map { !$0 }
            .drive(logOutButton.rx.isHidden)
            .disposed(by: rx.disposeBag)

        output.isLoggedIn
            .drive(logInButton.rx.isHidden)
            .disposed(by: rx.disposeBag)

        output.logInAction
            .drive()
            .disposed(by: rx.disposeBag)

        output.logOutAction
            .drive()
            .disposed(by: rx.disposeBag)
    }
}
