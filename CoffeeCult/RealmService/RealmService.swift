//
//  Container.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import Foundation
import RealmSwift

class RealmService {
    
    private init() {}
    static let shared = RealmService()
    
    var realm = try! Realm()
    
    private func errorPost(completion: @escaping() -> Void) {
        do {
            try realm.write { completion()
            }
        } catch {
            post(error)
        }
    }
    
    //MARK: - WriteTransaction
    
    func add<T: Persistable>(_ value: T, update: Bool = false) {
        errorPost {
            self.realm.add(value.managedObject(), update: .all)
        }
    }

    func add<T: Sequence>(_ values: T, update: Bool = false) where T.Iterator.Element: Persistable {
        errorPost {
            values.forEach { self.add($0, update: update) }
        }
    }
    
    func delete<T: Persistable>(_ value: T, primaryKey: String) {
        errorPost {
            guard let object = self.realm.object(ofType: T.ManagedObject.self, forPrimaryKey: primaryKey) else { return }
            self.realm.delete(object)
        }
    }
    
////  That Function looks perfect but it doesnt work((((((((((
//    func delete<T: Sequence>(_ values: T) where T.Iterator.Element: Persistable {
//        errorPost {
//            self.realm.delete(values.map { $0.managedObject() })
//        }
//    }
    
    func delete<T: Sequence>(_ values: T, primaryKeyArray: [String]) where T.Iterator.Element: Persistable {
        errorPost {
            let array = values.map { $0.managedObject() }
            var arrayToDelete = [T.Iterator.Element.ManagedObject]()
            for i in 0..<array.count {
                guard let object = self.realm.object(ofType: T.Iterator.Element.ManagedObject.self, forPrimaryKey: primaryKeyArray[i]) else { return }
                arrayToDelete.append(object)
            }
            self.realm.delete(arrayToDelete)
        }
    }
    
    func deleteAllType<T: Persistable>(_ type: T.Type) {
        errorPost {
            self.realm.delete(self.realm.objects(T.ManagedObject.self))
        }
    }
    
    func deleteAll() {
        errorPost {
            self.realm.deleteAll()
        }
    }
    
    func update<T: Persistable>(_ type: T.Type, values: [T.PropertyValue]) {
        var dictionary: [String: Any] = [:]

        values.forEach {
            let pair = $0.propertyValuePair
            dictionary[pair.name] = pair.value
        }
        
        realm.create(T.ManagedObject.self, value: dictionary, update: .all)
    }
    
    //MARK: - FetchedResults
    
    func values<T: Persistable> (_ type: T.Type, matching query: T.Query) -> FetchedResults<T> {
        var results = realm.objects(T.ManagedObject.self)

        if let predicate = query.predicate {
            results = results.filter(predicate)
        }

        results = results.sorted(by: query.sortDescriptors)

        return FetchedResults(results: results)
    }
    
    func allObjectValues<T: Persistable> (_ type: T.Type) -> FetchedResults<T> {
        let results = realm.objects(T.ManagedObject.self)
        return FetchedResults(results: results)
    }
    
    //MARK: - FetchingErrors
    
    func post(_ error: Error) {
        NotificationCenter.default.post(name: NSNotification.Name("RealmError"),
                                        object: error)
    }
    
    func observeRealmErrors(in vc: UIViewController, completion: @escaping(Error?) -> Void) {
        NotificationCenter.default.addObserver(forName: NSNotification.Name("RealmError"),
                                               object: nil,
                                               queue: nil) { (notification) in
            completion(notification.object as? Error)
        }
    }
    
    func stopObservingErrors(in vc: UIViewController) {
        NotificationCenter.default.removeObserver(vc,
                                                  name: NSNotification.Name("RealmError"),
                                                  object: nil)
    }
}
