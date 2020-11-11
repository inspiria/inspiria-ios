//
//  LoginViewController.swift
//  TReader
//
//  Created by tadas on 2020-07-31.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!

    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {

        let buttonAtt: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: ColorStyle.orange.color,
            .underlineStyle: NSUnderlineStyle.single.rawValue]

        let attString = NSMutableAttributedString(string: "Continue without log in", attributes: buttonAtt)

        continueButton.setAttributedTitle(attString, for: .normal)
    }

    private func bindViewModel() {
        let authorize = logInButton.rx.tap.asDriver()
        let skipAuthorize = continueButton.rx.tap.asDriver()

        let input = LoginViewModel.Input(authorize: authorize, skipAuthorize: skipAuthorize)
        let output = viewModel.transform(input: input)

        output.authorize
            .drive()
            .disposed(by: rx.disposeBag)

        output.skipAuthorize
            .drive()
            .disposed(by: rx.disposeBag)

        output.getToken
            .drive()
            .disposed(by: rx.disposeBag)

        output.error
            .drive(rx.errorBinding)
            .disposed(by: rx.disposeBag)

        output.activity
            .drive(rx.isRefreshingBinding)
            .disposed(by: rx.disposeBag)
    }
}
