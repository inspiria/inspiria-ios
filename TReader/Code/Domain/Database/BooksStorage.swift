//
//  BooksStorage.swift
//  TReader
//
//  Created by tadas on 2020-02-22.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import CoreData

class BooksSotrage {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BooksStorage")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        return container
    }()
}
