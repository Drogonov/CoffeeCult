//
//  PublisherObject.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import Foundation
import RealmSwift

final public class PublisherObject: Object {
    @objc dynamic var identifier = 0
    @objc dynamic var name = ""

    override public static func primaryKey() -> String? {
        return "identifier"
    }
}
