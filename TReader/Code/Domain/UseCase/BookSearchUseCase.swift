//
//  BookSearchUseCase.swift
//  TReader
//
//  Created by tadas on 2020-09-05.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol BookSearchUseCase {
    func search(query: String, in book: Book) -> Observable<[BookSearchResult]>
}

class DefaultBookSearchUseCase: BookSearchUseCase {
    private let filesService: BookFilesService
    private let prefixLenth = 25

    init(filesService: BookFilesService) {
        self.filesService = filesService
    }

    func search(query: String, in book: Book) -> Observable<[BookSearchResult]> {
        Observable.create { [weak self] observer -> Disposable in
            guard let `self` = self else { return Disposables.create() }
            do {
                var result = [BookSearchResult]()
                try book.chapters.forEach { chapter in
                    let file = self.filesService.getChapterUrl(id: book.info.id, chapterFile: chapter.fileName)
                    var data = try Data(contentsOf: file)
                    let text = try self.html2String(from: &data)
                    let regex = try NSRegularExpression(pattern: query, options: .caseInsensitive)
                    let range = NSRange(location: 0, length: text.utf16.count)

                    regex.enumerateMatches(in: text, options: [], range: range) { (match, _, _) in
                        guard let range = match?.range, range.location != NSNotFound else { return }
                        let lowerBound = max(0, range.lowerBound - self.prefixLenth)
                        let upperBound = min(text.count, range.upperBound + self.prefixLenth)
                        let start = text.index(text.startIndex, offsetBy: lowerBound)
                        let end = text.index(text.startIndex, offsetBy: upperBound)
                        let subString = text[start..<end]
                        let model = BookSearchResult(chapterId: chapter.id, chapterTitle: chapter.title, text: String(subString))
                        result.append(model)
                        observer.onNext(result)
                    }
                }
            } catch {
                observer.onError(error)
            }

            return Disposables.create()
        }
        .observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }

    func html2String(from: inout Data) throws -> String {
        let type = NSAttributedString.DocumentType.html
        let encoding = String.Encoding.utf8.rawValue
        let str = try NSAttributedString(data: from, options: [.documentType: type, .characterEncoding: encoding], documentAttributes: nil)
        return str.string
    }
}
