//
//  AnnotationNavigator.swift
//  TReader
//
//  Created by tadas on 2020-05-26.
//  Copyright (c) 2020 Scale3C. All rights reserved.
//

import UIKit

import RxCocoa

protocol AnnotationNavigator {
    func toEdit(annotation: Annotationable) -> Driver<String>
}

protocol AnnotationsLibratyNavigator {
    func toAnnotations()
}

class DefaultAnnotationsLibratyNavigator: AnnotationsLibratyNavigator, AnnotationNavigator {
    private let services: UseCaseProvider
    private let storyboard: UIStoryboard
    private let rootController: UINavigationController

    init(services: UseCaseProvider,
         storyboard: UIStoryboard,
         controller: UINavigationController) {
        self.services = services
        self.storyboard = storyboard
        self.rootController = controller
    }

    func toAnnotations() {
        let notesController: AnnotationViewController = storyboard.instantiateViewController()
        notesController.viewModel = AnnotationViewModel(annotationsUseCase: services.annotationsUseCase(),
                                                        navigator: self)
        rootController.viewControllers = [notesController]
    }

    func toEdit(annotation: Annotationable) -> Driver<String> {
        let navigator = DefaultEditAnnotationNavigator(services: services, controller: rootController)
        return navigator.toEditNote(annotation: annotation)
    }
}
