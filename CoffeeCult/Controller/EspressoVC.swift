//
//  EspressoVC.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import UIKit
import RealmSwift

protocol EspressoVCDelegate: class {
    func userProfileEditedVC(_ controller: EspressoVC)
}

class EspressoVC: UIViewController {
    
    // MARK: - Properties
    
    var user: User
    let realm = RealmService.shared.realm
    weak var delegate: EspressoVCDelegate?
    private var tableView = UITableView()
    var characterArray = [Character]()
    let fetchedUID = ["3BvgMLoeVYhORBSCmG4gldZHWMI2","uY7XTavrZXSETmON5kxhDwMthTG3", "yGcUuuTQCSdmBT4rUl6teTkrFk93", "H4satX3n4gTDGqYxYUmqBNEXKSH3"]
    
    private lazy var userProfileVC = UserProfileVC(user: user)
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("ViewWillAppear")
        configureData {
            self.tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        userProfileVC.delegate = self
        configureNavigationBar()
        configureTableView()
        configureData {
            self.requestData {
                self.configureData {
//                    print("TableView Reloaded")
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func requestData(completion: @escaping() -> Void) {
//        print("Data called from server")
        checkData { (wasDataDeleted) in
            self.fetchData(wasDataDeleted: wasDataDeleted) {
//                print("Data fetched and saved from server")
                completion()
            }
        }
    }
    
    func checkData(completion: @escaping(Bool) -> Void) {
        var wasDataDeleted: Bool
        if fetchedUID.count != characterArray.count {
            RealmService.shared.deleteAllType(Character.self)
//            print("Count != Data deleted")
            wasDataDeleted = true
            completion(wasDataDeleted)
        } else {
//            print("Count == Data doesnt deleted")
            wasDataDeleted = false
            completion(wasDataDeleted)
        }
    }
    
    func fetchData(wasDataDeleted: Bool, completion: @escaping() -> Void) {
        for i in 0..<fetchedUID.count{
            Service.shared.fetchUserData(uid: fetchedUID[i]) { (user) in
                let fetchedCharacter = Character(identifier: user.uid, name: user.fullname, realName: user.email, publisher: Publisher(identifier: 666, name: "Калипсо"))
//                print("Data fetched \(i)")
                self.saveData(fetchedCharacter: fetchedCharacter, i: i, wasDataDeleted: wasDataDeleted)
                completion()
            }
        }
    }
    
    func saveData(fetchedCharacter: Character, i: Int, wasDataDeleted: Bool) {
        if wasDataDeleted == true {
            RealmService.shared.add(fetchedCharacter)
//            print("Data \(i) != Data saved to realm")
            
        } else {
            if fetchedCharacter != characterArray[i] {
                RealmService.shared.add(fetchedCharacter)
//                print("Data \(i) != Data saved to realm")
            } else {
//                print("Data \(i) == Saving doesnt called")
            }
        }
    }
    
    func configureData(completion: @escaping() -> Void) {
        let results = RealmService.shared.allObjectValues(Character.self)
        characterArray = Array(results)
//        print("Data loaded from Realm")
        completion()
    }
    
    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCells()
        tableView.rowHeight = 50
        tableView.sectionHeaderHeight = 40
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = .secondarySystemBackground
        tableView.contentInsetAdjustmentBehavior = .never

        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor)
        
        tableView.reloadData()
        
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.systemRed
        navigationItem.title = "Espresso"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage().systemImage(withSystemName: "person.circle"), style: .plain, target: self, action: #selector(accountTapped))
    }
    
    // MARK: - Selectors
    
    @objc func accountTapped() {
        let controller = userProfileVC
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Protocol Functions
    
    func userProfileEdited() {
        delegate?.userProfileEditedVC(self)
    }
}


// MARK: - UITableViewDelegate

extension EspressoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.profileCell, for: indexPath) as! ProfileCell
        cell.baristaNameLabel.text = characterArray[indexPath.row].name
        cell.backgroundColor = .systemBackground
        cell.config = .profile
        tableView.rowHeight = cell.rowHeight
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        RealmService.shared.delete(characterArray[indexPath.row],
//                                   primaryKey: characterArray[indexPath.row].identifier)
        
        RealmService.shared.delete(characterArray, primaryKeyArray: arrayID())
        
    }
    
    func arrayID() -> [String] {
        var idArray = [String]()
        for i in 0..<characterArray.count {
            idArray.append(characterArray[i].managedObject().identifier)
        }
        return idArray
    }
}
