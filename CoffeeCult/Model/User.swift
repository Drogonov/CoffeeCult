//
//  User.swift
//  CoffeeCult
//
//  Created by Admin on 29.01.2021.
//

import Foundation

enum AccountType: Int {
    case barista
    case chief
}

struct User {
    var fullname: String
    let email: String
    var accountType: AccountType!
    let uid: String
    var profileImageUrl: String
    var companyName: String
    var companyID: String

    var firstInitial: String { return String(fullname.prefix(1)) }
}

extension User {
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.companyName = dictionary["companyName"] as? String ?? "Home Brewery"
        self.companyID = dictionary["companyID"] as? String ?? ""
        
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
    }
}

extension User: Persistable {
    init(managedObject: UserObject) {
        uid = managedObject.uid
        email = managedObject.email
        fullname = managedObject.fullname
        accountType = AccountType(rawValue: managedObject.accountType)
        profileImageUrl = managedObject.profileImageUrl
        companyName = managedObject.companyName
        companyID = managedObject.companyID
    }
    
    public func managedObject() -> UserObject {
        let user = UserObject()
        
        user.uid = uid
        user.email = email
        user.fullname = fullname
        user.accountType = accountType!.rawValue
        user.profileImageUrl = profileImageUrl
        user.companyName = companyName
        user.profileImageUrl = profileImageUrl
        
        return user
    }
}

