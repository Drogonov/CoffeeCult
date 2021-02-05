//
//  User.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import Foundation
import RealmSwift

public struct Character: Hashable {
    public let identifier: String
    public let name: String
    public let realName: String
    public let publisher: Publisher?
    
    public static func ==(lhs: Character, rhs: Character) -> Bool {
        return lhs.identifier == rhs.identifier && lhs.name == rhs.name
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(name)
    }
}

extension Character: Persistable {

    public init(managedObject: CharacterObject) {
        identifier = managedObject.identifier
        name = managedObject.name
        realName = managedObject.realName
        publisher = managedObject.publisher.flatMap(Publisher.init(managedObject:))
    }

    public func managedObject() -> CharacterObject {
        let character = CharacterObject()

        character.identifier = identifier
        character.name = name
        character.realName = realName
        character.publisher = publisher?.managedObject()

        return character
    }
}

extension Character {

    public enum PropertyValue: PropertyValueType {
        case identifier(String)
        case name(String)
        case realName(String)
        case publisher(Publisher?)

        public var propertyValuePair: PropertyValuePair {
            switch self {
            case .identifier(let id):
                return ("identifier", id)
            case .name(let name):
                return ("name", name)
            case .realName(let realName):
                return ("realName", realName)
            case .publisher(let publisher):
                return ("publisher", publisher?.managedObject() ?? NSNull())
            }
        }
    }
}

extension Character {

    public enum Query: QueryType {
        case publisherName(String)

        public var predicate: NSPredicate? {
            switch self {
            case .publisherName(let value):
                return NSPredicate(format: "publisher.name ==[c] %@", value)
            }
        }

        public var sortDescriptors: [SortDescriptor] {
            return [SortDescriptor(stringLiteral: "name")]
        }
    }
}
