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

    private var disposeBag = DisposeBag()
    private let usecase = DefaultUseCaseProvider.provider.bookUseCase()

    func set(book: BookState) {
        setCover(url: book.book.coverImageUrl)
        title.text = book.book.title

        if book.downloaded {
            progressHud.state = .downloaded
            return
        }

        disposeBag = DisposeBag()
        progressHud.state = .waiting

        progressHud.rx
            .tapGesture()
            .skip(1)
            .flatMap { [unowned self] _ in self.usecase.downloadBook(id: book.book.id) }
            .subscribe(onNext: { [unowned self] progress in
                if progress < 1 {
                    self.progressHud.state = .downloading
                    self.progressHud.progress = progress
                } else {
                    self.progressHud.state = .downloaded
                }
                }, onError: { [unowned self] error in
                    self.progressHud.state = Bool.random() ? .downloaded : .error
            }).disposed(by: disposeBag)
    }

    private func setCover(url: String) {
        let url = URL(string: url)
        let processor = DownsamplingImageProcessor(size: image.frame.size) |> RoundCornerImageProcessor(cornerRadius: 3)
        let scale = UIScreen.main.scale

        image.kf.cancelDownloadTask()
        image.kf.indicatorType = .activity
        image.kf.setImage(
            with: url,
            options: [.processor(processor),
                      .scaleFactor(scale),
                      .transition(.fade(1)),
                      .cacheOriginalImage,
                      .onFailureImage(#imageLiteral(resourceName: "BookCover"))
        ])
    }
}
