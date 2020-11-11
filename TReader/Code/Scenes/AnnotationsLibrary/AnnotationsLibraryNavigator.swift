//
//  AnnotationsLibraryNavigator.swift
//  TReader
//
//  Created by tadas on 2020-09-04.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

protocol AnnotationsLibraryNavigator {
    func toAnnotations()
}

class DefaultAnnotationsLibraryNavigator: AnnotationsLibraryNavigator {
    private let services: UseCaseProvider
    private let rootController: UINavigationController

    init(services: UseCaseProvider,
         controller: UINavigationController) {
        self.services = services
        self.rootController = controller
    }

    func toAnnotations() {
        let viewController = AnnotationsLibraryViewController()
        viewController.viewModel = AnnotationsLibraryViewModel(navigator: self)

        //PRESENT VIEW CONTROLLER
    }
}
