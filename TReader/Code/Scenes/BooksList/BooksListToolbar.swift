//
//  BooksListToolbar.swift
//  TReader
//
//  Created by tadas on 2020-02-23.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit

class BooksListToolbar: UIToolbar {

    enum State {
        case hidden, enabled, disabled
    }
    let removeButton: UIButton

    override init(frame: CGRect) {
        removeButton = UIButton(type: .custom)
        removeButton.tintColor = .white
        removeButton.setTitle("Remove", for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 19, weight: .bold)

        super.init(frame: frame)

        let container: UIView
        if frame.size.height <= 49 {
            container = removeButton
        } else {
            let stackView = UIStackView(arrangedSubviews: [removeButton, UIView()])
            stackView.axis = .vertical
            stackView.alignment = .trailing
            stackView.distribution = .fillEqually
            container = stackView
        }

        let remove = UIBarButtonItem(customView: container)
        let spacer1 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let spacer2 = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

        items = [spacer1, remove, spacer2]
        alpha = 0
        isTranslucent = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func set(state: State) {
        switch state {
        case .hidden:
            alpha = 0.0
        case .enabled:
            alpha = 1.0
            backgroundColor = ColorStyle.orange.color
            barTintColor = ColorStyle.orange.color
            removeButton.isEnabled = true
        case .disabled:
            alpha = 1.0
            backgroundColor = ColorStyle.menuGray.color
            barTintColor = ColorStyle.menuGray.color
            removeButton.isEnabled = false
        }
    }

}
