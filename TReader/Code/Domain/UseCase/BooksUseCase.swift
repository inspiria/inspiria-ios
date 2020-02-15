//
//  BooksUseCase.swift
//  TReader
//
//  Created by tadas on 2020-02-15.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

protocol BooksUseCase {
    func books() -> [Book]
}

class DefaultBooksUseCase: BooksUseCase {
    func books() -> [Book] {
        var books = [Book]()
        for index in 1...100 {
            let title = "This is book with id: \(index)" + (Bool.random() ? "\nand new line\nnew line\nnew line" : "")
            let image = "\(index % 11)"
            let book = Book(id: index, title: title, imageName: image)
            books.append(book)
        }
        return books
    }
}
