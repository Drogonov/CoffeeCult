//
//  LoginWithEmailVC.swift
//  CoffeeCult
//
//  Created by Admin on 04.02.2021.
//

import UIKit
import Firebase
import FirebaseAuth

protocol LoginWithEmailVCDelegate: class {
    func loginWithVCEmail(_ controller: LoginWithEmailVC)
}

class LoginWithEmailVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: LoginWithEmailVCDelegate?
    
    private lazy var userAuthView = UserAuthWithEmailView()
    private lazy var authBottomButton = AuthBottomButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
        
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
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: - Helper Functions
        
    func configureUI() {
        configureNavigationBar()
        configureUserAuthView()
        configureAuthBottomButton()
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    func configureUserAuthView() {
        userAuthView.delegate = self
        userAuthView.config = .login
        
        view.addSubview(userAuthView)
        userAuthView.centerX(inView: view)
        userAuthView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.safeAreaLayoutGuide.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor)
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func configureAuthBottomButton() {
        authBottomButton.delegate = self
        authBottomButton.config = .comeBack
        
        view.addSubview(authBottomButton)
        authBottomButton.centerX(inView: view)
        authBottomButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    // MARK: - Protocol Functions
    
    func handleLogin(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to log user in with error \(error.localizedDescription)")
                return
            }
            self.delegate?.loginWithVCEmail(self)
        }
    }
}

// MARK: - UserAuthViewDelegate

extension LoginWithEmailVC: UserAuthWithEmailViewDelegate {
    func handleAuthButton() {
        guard let email = userAuthView.emailTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let password = userAuthView.passwordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        handleLogin(email: email, password: password)
    }
}

// MARK: - AuthBottomButtonDelegate

extension LoginWithEmailVC: AuthBottomButtonDelegate {
    func handleAuthBottomButton(for button: AuthBottomButton) {
        handleShowLogin()
    }
}
