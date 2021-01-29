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
    weak var delegate: EspressoVCDelegate?
    private var tableView = UITableView()
    
//    private lazy var userProfileVC = UserProfileVC(user: user)
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        userProfileVC.delegate = self
        configureNavigationBar()
        configureTableView()
        
        let character = Character(
            identifier: 1455,
            name: "Iron Man",
            realName: "Tony Stark",
            publisher: Publisher(identifier: 1, name: "Marvel")
        )
        let container = try! Container()
        try! container.write { transaction in
            transaction.add(character)
        }

        
        
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
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
//        let controller = userProfileVC
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Protocol Functions
    
    func userProfileEdited() {
        delegate?.userProfileEditedVC(self)
    }
}

// MARK: - UserProfileVCDelegate

//extension EspressoVC: UserProfileVCDelegate {
//    func userProfileEditedVC(_ controller: UserProfileVC) {
//        self.user = controller.user
//        userProfileEdited()
//    }
//}

extension EspressoVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.profileCell, for: indexPath) as! ProfileCell
        cell.backgroundColor = .systemBackground
        cell.config = .profile
        tableView.rowHeight = cell.rowHeight
        return cell
    }
}
