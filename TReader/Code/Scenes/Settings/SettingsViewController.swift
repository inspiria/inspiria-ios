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
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var viewModel: SettingsViewModel!

    @IBOutlet var logInButton: UIButton!

    @IBOutlet weak var inputTextView: UITextView!
    @IBOutlet weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        bindViewModel()
    }

    func configureView() {
        let cornerRadius: CGFloat = 3.0

        inputTextView.layer.cornerRadius = cornerRadius
        inputTextView.layer.borderWidth = 1
        inputTextView.layer.borderColor = UIColor(hexString: "#E6E6E6")!.cgColor
        inputTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        saveButton.layer.cornerRadius = cornerRadius
    }

    private func bindViewModel() {
        let logInPressed = logInButton.rx.tap.asDriver().mapToVoid()
        let logOutPressed = Driver.just(()).skip(1)

        let input = SettingsViewModel.Input(logInPressed: logInPressed, logOutPressed: logOutPressed)
        let output = viewModel.transform(input: input)

        output.isLoggedIn
            .map { $0 ? "You are logged in." : "Login for note-taking and highlighting" }
            .drive(logInButton.rx.title())
            .disposed(by: rx.disposeBag)

        output.isLoggedIn
            .map { !$0 }
            .drive(logInButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)

        output.logInAction
            .drive()
            .disposed(by: rx.disposeBag)

//        output.logOutAction
//            .drive()
//            .disposed(by: rx.disposeBag)

        inputTextView.rx.text
            .asDriver()
            .map { $0 != nil && $0!.isEmpty == false }
            .drive(saveButton.rx.isEnabled)
            .disposed(by: rx.disposeBag)
    }

    @IBAction func composeEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = MFMailComposeViewController()
            mailComposeViewController.mailComposeDelegate = self
            mailComposeViewController.setToRecipients(["abc@abc.abc"])
            mailComposeViewController.setSubject("Subject")
            mailComposeViewController.setMessageBody(inputTextView.text, isHTML: false)
            present(mailComposeViewController, animated: true, completion: nil)
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
