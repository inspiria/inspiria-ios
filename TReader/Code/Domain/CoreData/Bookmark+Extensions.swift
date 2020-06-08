//
//  Bookmark+Extensions.swift
//  TReader
//
//  Created by tadas on 2020-06-08.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import CoreData
import RxCoreData
import RxDataSources

func == (lhs: Bookmark, rhs: Bookmark) -> Bool {
    return lhs.id == lhs.id
}

extension Bookmark: Equatable { }

extension Bookmark: IdentifiableType {
    typealias Identity = String
    var identity: Identity { return id }
}

extension Bookmark: Persistable {
    typealias T = NSManagedObject

    static var entityName: String {
        return "Event"
    }

    static var primaryAttributeName: String {
        return "id"
    }

    init(entity: T) {
        // swiftlint:disable force_cast
        title = entity.value(forKey: "title") as! String
        bookId = entity.value(forKey: "bookId") as! Int
        chapterId = entity.value(forKey: "chapterId") as! Int
        date = entity.value(forKey: "date") as! Date
        page = entity.value(forKey: "page") as! Int
        // swiftlint:enable force_cast
    }

    func update(_ entity: T) {
        entity.setValue(id, forKey: "id")
        entity.setValue(title, forKey: "title")
        entity.setValue(bookId, forKey: "bookId")
        entity.setValue(chapterId, forKey: "chapterId")
        entity.setValue(date, forKey: "date")
        entity.setValue(page, forKey: "page")

        do {
            try entity.managedObjectContext?.save()
        } catch let error {
            print(error)
        }
    }

}
