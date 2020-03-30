//
//  BookProcessor.swift
//  TReader
//
//  Created by tadas on 2020-03-25.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import SwiftSoup

class BookProcessor {
    private let id: Int
    private let url: URL
    private let filesService: BookFilesService

    init(id: Int, url: URL, filesService: BookFilesService) {
        self.id = id
        self.url = url
        self.filesService = filesService
    }

    func process() throws {
        var data = try Data(contentsOf: url, options: .mappedIfSafe)
        var book = try Book(data: data)

        let chapters = try book.chapters.map { chapter -> Chapter in
//            var chapter = chapter
//            chapter.text = try processImagesTag(string: chapter.text)
            return chapter
        }

        let authors = try book.authors.map { author -> Author in
            var author = author
            let path = filesService.getBookUrl(id: id).absoluteString
            author.bio = try processImagesTag(string: author.bio)
            author.pictureUrl = author.pictureName.flatMap { path + $0 }
            return author
        }

        book = Book(info: book.info, authors: authors, chapters: chapters)
        data = try book.jsonData()
        try data.write(to: url)
    }

    private func processImagesTag(string: String) throws -> String {
        let path = filesService.getBookUrl(id: id).absoluteString

        let doc: Document = try SwiftSoup.parse(string)
        let img = try doc.select("img")
        _ = try img.map { elem in
            try elem.attr("src", path + (elem.getAttributes()?.get(key: "src") ?? ""))
            try elem.attr("width", "\(UIScreen.main.bounds.width - 24)")
        }
        let result = try doc.html()
        return result
    }
}
