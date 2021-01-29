//
//  Publisher.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import Foundation

public struct Publisher {
    public let identifier: Int
    public let name: String
}

extension Publisher: Persistable {

    public init(managedObject: PublisherObject) {
        identifier = managedObject.identifier
        name = managedObject.name
    }

    public func managedObject() -> PublisherObject {
        let publisher = PublisherObject()

        publisher.identifier = identifier
        publisher.name = name

        return publisher
    }
}
