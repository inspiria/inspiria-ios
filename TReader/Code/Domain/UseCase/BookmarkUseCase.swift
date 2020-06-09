//
//  BookmarkUseCase.swift
//  TReader
//
//  Created by tadas on 2020-05-30.
//  Copyright © 2020 Scale3C. All rights reserved.
//

import Foundation
import CoreData
import RxSwift
import RxCocoa
import RxCoreData

protocol BookmarkUseCase {
    func getBookmarks(book: Int) -> Observable<[Bookmark]>
    func add(bookmark: Bookmark)
    func remove(bookmark: Bookmark)
    func bookmark(book: Int, chapter: Int) -> Bookmark?
}

class DefaultBookmarkUseCase: BookmarkUseCase {
    private let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    func getBookmarks(book: Int) -> Observable<[Bookmark]> {
        let predicate = NSPredicate(format: "bookId = \(book)")
        let descriptors = [NSSortDescriptor(key: "date", ascending: false)]
        return managedObjectContext.rx
            .entities(Bookmark.self, predicate: predicate, sortDescriptors: descriptors)
    }

    func add(bookmark: Bookmark) {
        do {
            try managedObjectContext.rx.update(bookmark)
        } catch {
            print(error)
        }
    }

    func remove(bookmark: Bookmark) {
        do {
            try managedObjectContext.rx.delete(bookmark)
        } catch {
            print(error)
        }
    }

    func bookmark(book: Int, chapter: Int) -> Bookmark? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: Bookmark.entityName)
        fetchRequest.predicate = NSPredicate(format: "%K = %@", Bookmark.primaryAttributeName, "\(book)-\(chapter)")
        let result = (try? managedObjectContext.execute(fetchRequest)) as? NSAsynchronousFetchResult<NSManagedObject>
        return result?.finalResult?.first.flatMap { Bookmark(entity: $0) }
    }
}
