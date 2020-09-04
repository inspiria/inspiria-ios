//
//  EditNoteNavigator.swift
//  TReader
//
//  Created by tadas on 2020-07-14.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit
import SideMenu

import RxSwift
import RxCocoa

protocol EditAnnotationNavigator {
    func toEditNote(annotation: Annotationable) -> Single<String>
}

class DefaultEditAnnotationNavigator: EditAnnotationNavigator {
    private let services: UseCaseProvider
    private let rootController: UINavigationController

    init(services: UseCaseProvider,
         controller: UINavigationController) {
        self.services = services
        self.rootController = controller
    }

    func toEditNote(annotation: Annotationable) -> Single<String> {
        let viewController = EditAnnotationViewController()
        viewController.viewModel = EditAnnontationViewModel(navigator: self, annotation: annotation)

        let menu = SideMenuNavigationController(rootViewController: viewController)
        menu.presentationStyle = .menuDissolveIn
        menu.presentationStyle.presentingEndAlpha = 0.65
        menu.settings.menuWidth = UIScreen.main.bounds.width - 40.0
        menu.settings.statusBarEndAlpha = 0

        rootController.present(menu, animated: true, completion: nil)

        return viewController.viewModel.updatedText
    }
}
