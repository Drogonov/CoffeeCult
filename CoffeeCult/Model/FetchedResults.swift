//
//  FetchedResults.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import Foundation
import RealmSwift

public final class FetchedResults<T: Persistable> {

    internal let results: Results<T.ManagedObject>

    public var count: Int {
        return results.count
    }

    internal init(results: Results<T.ManagedObject>) {
        self.results = results
    }

    public func value(at index: Int) -> T {
        return T(managedObject: results[index])
    }
}

// MARK: - Collection

extension FetchedResults: Collection {

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }

    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }

    public subscript(position: Int) -> T {
        return value(at: position)
    }
}
