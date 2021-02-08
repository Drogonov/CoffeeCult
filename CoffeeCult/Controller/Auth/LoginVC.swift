//
//  LoginVC.swift
//  CoffeeCult
//
//  Created by Admin on 29.01.2021.
//

import UIKit
import Firebase
import FirebaseAuth

protocol LoginVCDelegate: class {
    func userLoginVC(_ controller: LoginVC)
}

class LoginVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: LoginVCDelegate?
    
    private lazy var userAuthWithView: UserAuthWithView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let view = UserAuthWithView(frame: frame, config: .login)
        return view
    }()
    private lazy var authBottomButton = AuthBottomButton()
    private lazy var loginWithEmailVC = LoginWithEmailVC()
    private lazy var singUpVC = SignUpVC()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helper Functions
        
    func configureUI() {
        loginWithEmailVC.delegate = self
        singUpVC.delegate = self
    
        configureNavigationBar()
        configureUserAuthWithView()
        configureAuthBottomButton()
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
    }
    
    func configureUserAuthWithView() {
        userAuthWithView.delegate = self
        
        view.addSubview(userAuthWithView)
        userAuthWithView.centerX(inView: view)
        userAuthWithView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            left: view.safeAreaLayoutGuide.leftAnchor,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            right: view.safeAreaLayoutGuide.rightAnchor)
    }
    
    func configureAuthBottomButton() {
        authBottomButton.delegate = self
        authBottomButton.config = .login
        
        view.addSubview(authBottomButton)
        authBottomButton.centerX(inView: view)
        authBottomButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func handleShowSignUp() {
        navigationController?.pushViewController(singUpVC, animated: true)
        navigationController?.navigationBar.isHidden = true
    }
    
    func handleShowLoginWithEmail() {
        navigationController?.pushViewController(loginWithEmailVC, animated: true)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - UserAuthWithViewDelegate

extension LoginVC: UserAuthWithViewDelegate {
    func handleAuthButton(withConfig config: AuthWithButtonConfiguration) {
        switch config {
        case .email:
            handleShowLoginWithEmail()
        case .google:
            print("Login with Google")
        case .facebook:
            print("Login with Facebook")
        case .apple:
            print("Login with Apple")
        }
    }
}

// MARK: - AuthBottomButtonDelegate

extension LoginVC: AuthBottomButtonDelegate {
    func handleAuthBottomButton(for button: AuthBottomButton) {
        handleShowSignUp()
    }
}

// MARK: - LoginWithEmailVCDelegate

extension LoginVC: LoginWithEmailVCDelegate {
    func loginWithVCEmail(_ controller: LoginWithEmailVC) {
        delegate?.userLoginVC(self)
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SignUpVCDelegate

extension LoginVC: SignUpVCDelegate {
    func userSignUpVC(_ controller: SignUpVC) {
        delegate?.userLoginVC(self)
        self.dismiss(animated: true, completion: nil)
    }
}

