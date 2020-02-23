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


    private var disposeBag = DisposeBag()
    //FIXME: Not nice, maybe introduce BookCellViewModel?
    private let bookUseCase = DefaultUseCaseProvider.provider.booksUseCase()

    func set(book: BookInfo) {
        setCover(url: book.coverImageUrl)
        title.text = book.title
        disposeBag = DisposeBag()

        if bookUseCase.isBookDownloaded(id: book.id) {
            progressHud.state = .downloaded
            return
        }

        progressHud.state = .waiting

        progressHud.rx
            .tapGesture()
            .skip(1)
            .flatMap { [unowned self] _ in self.bookUseCase.downloadBook(id: book.id) }
            .subscribe(onNext: { [unowned self] progress in
                if progress < 1 {
                    self.progressHud.state = .downloading
                    self.progressHud.progress = progress
                } else {
                    self.progressHud.state = .downloaded
                    self.set(book: book)
                }
                }, onError: { [unowned self] error in
                    self.set(book: book)
                    self.progressHud.state = .error
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
                      .cacheOriginalImage,
                      .onFailureImage(#imageLiteral(resourceName: "BookCover"))
        ])
    }
}
