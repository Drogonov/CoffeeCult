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
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.companyName = dictionary["companyName"] as? String ?? "Home Brewery"
        self.companyID = dictionary["companyID"] as? String ?? ""
        
        if let index = dictionary["accountType"] as? Int {
            self.accountType = AccountType(rawValue: index)
        }
    }
}
