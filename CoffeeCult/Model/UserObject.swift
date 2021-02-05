//
//  UserObject.swift
//  CoffeeCult
//
//  Created by Admin on 29.01.2021.
//

import Foundation
import RealmSwift

final class UserObject: Object {
    @objc dynamic var uid = ""
    @objc dynamic var email = ""
    @objc dynamic var fullname = ""
    @objc dynamic var accountType = 0
    @objc dynamic var profileImageUrl = ""
    @objc dynamic var companyName = ""
    @objc dynamic var companyID = ""
    
    override static func primaryKey() -> String? {
        return "uid"
    }
}
