//
//  NotesNavigator.swift
//  TReader
//
//  Created by tadas on 2020-05-26.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

protocol NotesNavigator {
    func toNotes()
}

class DefaultNotesNavigator: NotesNavigator {
    private let services: UseCaseProvider
    private let rootController: UINavigationController

    init(services: UseCaseProvider,
         controller: UINavigationController) {
        self.services = services
        self.rootController = controller
    }

    func toNotes() {
        let viewController = NotesViewController()
        viewController.viewModel = NotesViewModel(navigator: self)

        //PRESENT VIEW CONTROLLER
    }
}
