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
    @IBOutlet weak var progress: BooksListItemProgress!

    var disposeBag = DisposeBag()

    func set(book: Book) {
        setCover(url: book.coverImageUrl)
        title.text = book.title

        disposeBag = DisposeBag()
        progress.state = .waiting

        progress.rx
            .tapGesture()
            .skip(1)
            .map { _ in }
            .subscribe(onNext: animate)
            .disposed(by: disposeBag)
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

    private func animate() {
        progress.state = .downloading
        progress.progress = 0.0

        let timer = Observable<Int>.interval(0.01, scheduler: MainScheduler.instance)
        timer.subscribe(onNext: { [unowned self] _ in
            if self.progress.progress < 1 {
                self.progress.state = .downloading
                self.progress.progress += 0.02
            } else {
                self.progress.state = Bool.random() ? .downloaded : .error
                self.disposeBag = DisposeBag()
            }
        }).disposed(by: disposeBag)
    }
}
