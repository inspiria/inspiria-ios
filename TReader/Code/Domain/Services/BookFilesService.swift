//
//  BookFilesService.swift
//  TReader
//
//  Created by tadas on 2020-03-25.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation

protocol BookFilesService {
    func bookFilesExists(id: Int) -> Bool
    func getBookUrl(id: Int) -> URL
    func getBookFileUrl(id: Int) -> URL
    func getBookZiptUrl(id: Int) -> URL

    func removeBook(id: Int) -> Bool
    func removeBookZip(id: Int) -> Bool
}

class DefaultBookFilesService: BookFilesService {
    private let manager: FileManager

    private let bookFileName = "book.json"
    private let zipFileExtension = ".zip"

    init(manager: FileManager) {
        self.manager = manager
    }

    func bookFilesExists(id: Int) -> Bool {
        do {
            let path = getBookFileUrl(id: id)
            return try path.checkResourceIsReachable()
        } catch {
            return false
        }
    }

    func getBookUrl(id: Int) -> URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let path = paths[0].appendingPathComponent("\(id)", isDirectory: true)
        return path
    }

    func getBookFileUrl(id: Int) -> URL {
        return getBookUrl(id: id).appendingPathComponent(bookFileName)
    }

    func getBookZiptUrl(id: Int) -> URL {
        return getBookUrl(id: id).appendingPathExtension(zipFileExtension)
    }

    func removeBook(id: Int) -> Bool {
        let url = getBookUrl(id: id)
        do {
            try manager.removeItem(at: url)
            return true
        } catch {
            return false
        }
    }

    func removeBookZip(id: Int) -> Bool {
        let url = getBookZiptUrl(id: id)
        do {
            try manager.removeItem(at: url)
            return true
        } catch {
            return false
        }
    }
}
