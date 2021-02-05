//
//  FetchedResults.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import Foundation
import RealmSwift

final class FetchedResults<T: Persistable> {

    internal let results: Results<T.ManagedObject>

    var count: Int {
        return results.count
    }

    internal init(results: Results<T.ManagedObject>) {
        self.results = results
    }

    func value(at index: Int) -> T {
        return T(managedObject: results[index])
    }
}

// MARK: - Collection

extension FetchedResults: Collection {

    var startIndex: Int {
        return 0
    }

    var endIndex: Int {
        return count
    }

    func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }

    subscript(position: Int) -> T {
        return value(at: position)
    }
}
