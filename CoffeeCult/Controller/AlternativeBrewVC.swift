//
//  AlternativeBrewVC.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import UIKit
import Firebase
import FirebaseAuth
import RealmSwift

protocol AlternativaBrewVCDelegate: class {
    func userSignOut(_ controller: AlternativeBrewVC)
}

class AlternativeBrewVC: UIViewController {

    // MARK: - Properties
    
    weak var delegate: AlternativaBrewVCDelegate?
    var user: User
    
    private lazy var authBottomButton = AuthBottomButton()
    
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
        configureUI()

    }
    
    // MARK: - Selectors
    
    @objc func accountTapped() {
        userSignOut()
    }
        
    // MARK: - Helper Functions
    
    
    func configureUI() {
        configureNavigationBar()
        
        authBottomButton.delegate = self
        authBottomButton.config = .comeBack
        view.addSubview(authBottomButton)
        authBottomButton.centerX(inView: view)
        authBottomButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.tintColor = UIColor.systemRed
        navigationItem.title = "Alternative Brew"
  
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(accountTapped))
    }
    
    // MARK: - Protocol Functions
    
    func userSignOut() {
        delegate?.userSignOut(self)
    }
}

extension AlternativeBrewVC: AuthBottomButtonDelegate {
    func handleAuthBottomButton(for button: AuthBottomButton) {
        print(authBottomButton.config)
        userSignOut()
    }
}
