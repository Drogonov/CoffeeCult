//
//  Service.swift
//  CoffeeCult
//
//  Created by Admin on 29.01.2021.
//

import Firebase

// MARK: - DatabaseRefs

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_COMPANIES = DB_REF.child("companies")
let REF_CAFES = DB_REF.child("cafes")
let REF_REQUESTS = DB_REF.child("requests")

// MARK: - SharedService

enum UserDataConfiguration {
    case barista
    case chief
    
    init() {
        self = .barista
    }
}

enum ChangeUserValueConfiguration {
    case fullname
    case accountType
    case profileImageUrl
    case companyID
    case companyName
    
    init() {
        self = .fullname
    }
}

struct Service {
    static let shared = Service()
    
    func connectionCheck(completion: @escaping(Bool) -> Void) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { (snapshot) in
          if snapshot.value as? Bool ?? false {
            completion(true)
          } else {
            completion(false)
          }
        })
    }
    
    // MARK: - FetchData
    
    func fetchUserData(uid: String, completion: @escaping(User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            let user = User(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
//    func fetchCompanyData(companyID: String, completion: @escaping(Company) -> Void) {
//        REF_COMPANIES.child(companyID).observeSingleEvent(of: .value) { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            let companyID = snapshot.key
//            let company = Company(companyID: companyID, dictionary: dictionary)
//            completion(company)
//        }
//    }
//
//    func fetchCafeData(cafeID: String, completion: @escaping(Cafe) -> Void) {
//        REF_CAFES.child(cafeID).observeSingleEvent(of: .value) { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            let cafeID = snapshot.key
//            let cafe = Cafe(cafeID: cafeID, dictionary: dictionary)
//            completion(cafe)
//        }
//    }
//
//    func fetchRequest(requestID: String, completion: @escaping(Request) -> Void) {
//        REF_REQUESTS.child(requestID).observeSingleEvent(of: .value) { (snapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            let requestID = snapshot.key
//            let request = Request(requestID: requestID, dictionary: dictionary)
//            completion(request)
//        }
//    }
    
    func fetchRequestsByEmail(config: UserDataConfiguration, email: String, completion: @escaping(Int, [String]) -> Void) {
        var child: String
        switch config {
        case .barista:
            child = "emailBarista"
        case .chief:
            child = "emailChief"
        }
        REF_REQUESTS.queryOrdered(byChild: child).queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
                let requests = snapshot.value as! NSDictionary
                let requestsKeyArray = requests.allKeys as! [String]
                completion(requests.count, requestsKeyArray)
            }
        }
    }
    
    // MARK: - ChangeData
    
    func changeBaristaStatus(cafeID: String, baristaID: String, status: Int, completion: @escaping(Error?, DatabaseReference) -> Void) {
        REF_CAFES.child(cafeID).child("barista").child(baristaID).child("status").setValue(status, withCompletionBlock: completion)
    }
    
    func changeRequestStatus(requestID: String, status: Int, completion: @escaping(Error?, DatabaseReference) -> Void) {
        REF_REQUESTS.child(requestID).child("status").setValue(status, withCompletionBlock: completion)
    }
    
    func deleteRequest(requestID: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        REF_REQUESTS.child(requestID).removeValue(completionBlock: completion)
    }
    
    func changeUserValue(userID: String, config: ChangeUserValueConfiguration, value: Any, completion: @escaping(Error?, DatabaseReference) -> Void) {
        var child: String
        switch config {
        case .fullname:
            child = "fullname"
        case .accountType:
            child = "accountType"
        case .profileImageUrl:
            child = "profileImageUrl"
        case .companyID:
            child = "companyID"
        case .companyName:
            child = "companyName"
        }
        REF_USERS.child(userID).child(child).setValue(value, withCompletionBlock: completion)
    }
    
    func deleteBaristaFromCompany(baristaUID: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        let values = ["companyID": "",
                      "companyName": "Home Brewery"] as [String: Any]
        
        REF_USERS.child(baristaUID).updateChildValues(values, withCompletionBlock: completion)
    }
    
    func deleteBaristaFromCafe(cafeID: String, baristaID: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        REF_CAFES.child(cafeID).child("barista").child(baristaID).removeValue(completionBlock: completion)
    }
}

// MARK: - ChiefService

struct ChiefService {
    static let shared = ChiefService()
    
    // MARK: - FetchData
    
    func checkIfUserExistByEmail(email: String, completion: @escaping(Bool, String) -> Void) {
        REF_USERS.queryOrdered(byChild: "email").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
            var baristaExist: Bool
            var baristaUID: String
            if snapshot.exists() {
                let requests = snapshot.value as! NSDictionary
                let requestsKeyArray = requests.allKeys as! [String]
                baristaUID = requestsKeyArray[0]
                baristaExist = true
            } else {
                baristaUID = ""
                baristaExist = false
            }
            print(baristaExist)
            print(baristaUID)
            completion(baristaExist, baristaUID)
        }
    }
    
//    func doesBaristaGetRequest(email: String, user: User, completion: @escaping(Bool) -> Void) {
//        var requestsArray = [Request]()
//        var requestSended = false
//        REF_REQUESTS.queryOrdered(byChild: "emailBarista").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
//            if snapshot.exists() {
//                let requests = snapshot.value as! NSDictionary
//                let requestsKeyArray = requests.allKeys as! [String]
//                for i in 0..<(requests.count) {
//                    Service.shared.fetchRequest(requestID: requestsKeyArray[i]) { (requests) in
//                        requestsArray.append(requests)
//                        requestsArray = requestsArray.removingDuplicates()
//                        if requests.emailChief == user.email {
//                            requestSended = true
//                        }
//                        completion(requestSended)
//                    }
//                }
//            } else {
//                requestSended = false
//                completion(requestSended)
//            }
//        }
//    }
    
    // MARK: - ChangeData
    
    func uploadRequest(emailChief: String, emailBarista: String, chiefUID: String, cafeID: String, companyID: String, baristaUID: String, completion: @escaping(Error?, DatabaseReference, String) -> Void) {
        let values = ["emailChief": emailChief,
                      "emailBarista": emailBarista,
                      "status": 0,
                      "chiefUID": chiefUID,
                      "cafeID": cafeID,
                      "companyID": companyID,
                      "baristaUID": baristaUID] as [String : Any]
        guard let requestID = REF_REQUESTS.childByAutoId().key else { return }
        REF_REQUESTS.child(requestID).updateChildValues(values) { (err, ref) in
            completion(err, ref, requestID)
        }
    }
    
    func uploadBaristaToCafe(cafeID: String, baristaUID: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        let values = ["baristaUID": baristaUID,
                      "status": 0] as [String : Any]
        
        REF_CAFES.child(cafeID).child("barista").childByAutoId().updateChildValues(values, withCompletionBlock: completion)
    }
    
}

// MARK: - BaristaService

struct BaristaService {
    static let shared = BaristaService()
    
    // MARK: - FetchData
    
    func lookForTheRequest(email: String, completion: @escaping(Bool) -> Void) {
        REF_REQUESTS.queryOrdered(byChild: "emailBarista").queryEqual(toValue: email).observeSingleEvent(of: .value) { (snapshot) in
            guard (snapshot.value as? NSDictionary) != nil else { return }
            completion(true)
        }
    }
}

