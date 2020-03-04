//
//  BooksListItemCell.swift
//  TReader
//
//  Created by tadas on 2020-02-14.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import Kingfisher

class BooksListItemCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var progressHud: BooksListItemProgress!
    @IBOutlet weak var selection: UIImageView!

    private var disposeBag: DisposeBag!
    private var viewModel: BooksListItemViewModel!

    func set(viewModel: BooksListItemViewModel) {
        self.viewModel = viewModel
        disposeBag = DisposeBag()

        let output = viewModel.transform()

        output.book
            .map { $0.title }
            .drive(title.rx.text)
            .disposed(by: disposeBag)

        output.book
            .map { $0.coverImageUrl }
            .drive(imageUrl)
            .disposed(by: disposeBag)

        output.state
            .drive(state)
            .disposed(by: disposeBag)

        output.downloadProgress
            .drive(onNext: { [unowned self] in self.progressHud.progress = $0 })
            .disposed(by: disposeBag)

    }
}

extension BooksListItemCell {
    fileprivate var state: Binder<BooksListItemViewModel.HoodState> {
        return Binder<BooksListItemViewModel.HoodState>(self, binding: { cnt, state in
            cnt.progressHud.state = state

            switch (state) {
            case .deselected:
                cnt.selection.isHidden = false
                cnt.selection.image =  #imageLiteral(resourceName: "SelectOpen")
            case .selected:
                cnt.selection.isHidden = false
                cnt.selection.image = #imageLiteral(resourceName: "SelectCheck")
            default:
                cnt.selection.isHidden = true
            }
        })
    }

    fileprivate var imageUrl: Binder<String> {
        return Binder<String>(self, binding: { controller, url in
            let url = URL(string: url)
            let processor = DownsamplingImageProcessor(size: self.image.frame.size) |> RoundCornerImageProcessor(cornerRadius: 3)
            let scale = UIScreen.main.scale

            controller.image.kf.cancelDownloadTask()
            controller.image.kf.indicatorType = .activity
            controller.image.kf.setImage(
                with: url,
                options: [.processor(processor),
                          .scaleFactor(scale),
                          .transition(.fade(1)),
                          .cacheOriginalImage,
                          .cacheOriginalImage,
                          .onFailureImage(#imageLiteral(resourceName: "BookCover"))
            ])
        })
    }
}
