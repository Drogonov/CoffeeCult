//
//  CharacterObject.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import Foundation
import RealmSwift

final public class CharacterObject: Object {
    @objc dynamic var identifier = ""
    @objc dynamic var name = ""
    @objc dynamic var realName = ""
    @objc dynamic var publisher: PublisherObject?

    override public static func primaryKey() -> String? {
        return "identifier"
    }
}
