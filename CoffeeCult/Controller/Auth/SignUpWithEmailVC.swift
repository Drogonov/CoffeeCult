//
//  SignUpWithEmailVC.swift
//  CoffeeCult
//
//  Created by Admin on 04.02.2021.
//

import UIKit
import Firebase
import FirebaseAuth

protocol SignUpWithEmailVCDelegate: class {
    func signUpWithVCEmail(_ controller: SignUpWithEmailVC)
}

class SignUpWithEmailVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: SignUpWithEmailVCDelegate?
    
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
    
    // MARK: - API
    
    func connectionCheck(completion: @escaping(Bool) -> Void) {
        Service.shared.connectionCheck { (doesUserConnected) in
            if doesUserConnected == true {
                completion(doesUserConnected)
            } else {
                self.configureNetworkDisconnectedNotification()
                completion(doesUserConnected)
            }
        }
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
    }
    
    func configureAuthBottomButton() {
        authBottomButton.delegate = self
        authBottomButton.config = .comeBack
        
        view.addSubview(authBottomButton)
        authBottomButton.centerX(inView: view)
        authBottomButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func configureNetworkDisconnectedNotification() {
        showNotification(title: "Кажется у вас проблемы с сетью",
                         message: "Подключен ли интернет?",
                         defaultAction: true,
                         defaultActionText: "OK") { (config, _) in
            switch config {
            default: break
            }
        }
    }
    
    // MARK: - Protocol Functions
        
    func handleSignUp(email: String, password: String, fullname: String, accountTypeIndex: Int) {
        
        connectionCheck { (doesUserConnected) in
            if doesUserConnected == true {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let error = error {
                        print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    let values = ["email": email,
                                  "fullname": fullname,
                                  "accountType": accountTypeIndex] as [String : Any]
                    
                    Service.shared.updateUserValues(uid: uid, values: values) { (err, ref) in
                        if let error = error {
                            print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                            return
                        }
                        self.delegate?.signUpWithVCEmail(self)
                    }
                }
            }
        }
    }
}

// MARK: - UserAuthViewDelegate

extension SignUpWithEmailVC: UserAuthWithEmailViewDelegate {
    func handleAuthButton() {
        guard let email = userAuthView.emailTextField.text?.localizedLowercase.trimmingCharacters(in: .whitespaces) else { return }
        guard let password = userAuthView.passwordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let fullname = userAuthView.fullnameTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        let accountTypeIndex = userAuthView.accountTypeSegmentedControl.selectedSegmentIndex
 
        handleSignUp(email: email, password: password, fullname: fullname, accountTypeIndex: accountTypeIndex)
    }
}

// MARK: - AuthBottomButtonDelegate

extension SignUpWithEmailVC: AuthBottomButtonDelegate {
    func handleAuthBottomButton(for button: AuthBottomButton) {
        handleShowLogin()
    }
}
