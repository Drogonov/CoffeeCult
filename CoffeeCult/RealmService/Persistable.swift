//
//  Persistable.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import Foundation
import RealmSwift

/// Represents a type that can be persisted using Realm.
public protocol Persistable {

    associatedtype ManagedObject: RealmSwift.Object
    associatedtype PropertyValue: PropertyValueType = DefaultPropertyValue
    associatedtype Query: QueryType = DefaultQuery

    init(managedObject: ManagedObject)

    func managedObject() -> ManagedObject
}

public typealias PropertyValuePair = (name: String, value: Any)

/// Represents a property value
public protocol PropertyValueType {
    var propertyValuePair: PropertyValuePair { get }
}

public enum DefaultPropertyValue: PropertyValueType {

    public var propertyValuePair: PropertyValuePair {
        return ("", 0)
    }
}

/// Represents a Query
public protocol QueryType {
    var predicate: NSPredicate? { get }
    var sortDescriptors: [SortDescriptor] { get }
}

public enum DefaultQuery: QueryType {

    public var predicate: NSPredicate? {
        return nil
    }

    public var sortDescriptors: [SortDescriptor] {
        return []
    }
}
