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
    private lazy var userAuthView = UserAuthView()
    private lazy var authWithButton = AuthWithButton()
    
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
    
    @objc func Keyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            userAuthView.logoSize = 125
            UIView.animate(withDuration: 0.5, animations: {
                self.userAuthView.logoImageViewHeightConstraint.constant = self.userAuthView.logoSize
                self.userAuthView.logoImageViewWidthConstraint.constant = self.userAuthView.logoSize
            })
        } else {
            userAuthView.logoSize = 70
            UIView.animate(withDuration: 0.5, animations: {
                self.userAuthView.logoImageViewHeightConstraint.constant = self.userAuthView.logoSize
                self.userAuthView.logoImageViewWidthConstraint.constant = self.userAuthView.logoSize
              })
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - Helper Functions
    
    
    func configureUI() {
        configureNavigationBar()
        
        userAuthView.delegate = self
        userAuthView.config = .signUp
        view.addSubview(userAuthView)
        userAuthView.centerX(inView: view)
        userAuthView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.safeAreaLayoutGuide.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor)
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        authBottomButton.delegate = self
        authBottomButton.config = .comeBack
        view.addSubview(authBottomButton)
        authBottomButton.centerX(inView: view)
        authBottomButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
        authWithButton.delegate = self
        authWithButton.config = .facebook
        view.addSubview(authWithButton)
        authWithButton.centerX(inView: view)
        authWithButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.safeAreaLayoutGuide.leftAnchor,
                              right: view.safeAreaLayoutGuide.rightAnchor,
                              paddingTop: 40)
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
    }
}

extension AlternativeBrewVC: UserAuthViewDelegate {
    func handleAuthButton() {
        print(userAuthView.config)
    }
}

extension AlternativeBrewVC: AuthWithButtonDelegate {
    func handleAuthWithButton(for button: AuthWithButton) {
        print(authWithButton.config)
    }
}
