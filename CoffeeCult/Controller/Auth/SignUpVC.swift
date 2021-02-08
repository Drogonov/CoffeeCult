//
//  SignUpVC.swift
//  CoffeeCult
//
//  Created by Admin on 29.01.2021.
//

import UIKit
import Firebase
import FirebaseAuth

protocol SignUpVCDelegate: class {
    func userSignUpVC(_ controller: SignUpVC)
}

class SignUpVC: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: SignUpVCDelegate?
    
    private lazy var userAuthWithView: UserAuthWithView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let view = UserAuthWithView(frame: frame, config: .signUp)
        return view
    }()
    private lazy var authBottomButton = AuthBottomButton()
    private lazy var signUpWithEmailVC = SignUpWithEmailVC()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        signUpWithEmailVC.delegate = self
    
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
        authBottomButton.config = .signUp
        
        view.addSubview(authBottomButton)
        authBottomButton.centerX(inView: view)
        authBottomButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
    
    func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    func handleShowSignUpWithEmail() {
        navigationController?.pushViewController(signUpWithEmailVC, animated: true)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - UserAuthWithViewDelegate

extension SignUpVC: UserAuthWithViewDelegate {
    func handleAuthButton(withConfig config: AuthWithButtonConfiguration) {
        switch config {
        case .email:
            handleShowSignUpWithEmail()
        case .google:
            print("Sign up with Google")
        case .facebook:
            print("Sign up with Facebook")
        case .apple:
            print("Sign up with Apple")
        }
    }
}

// MARK: - AuthBottomButtonDelegate

extension SignUpVC: AuthBottomButtonDelegate {
    func handleAuthBottomButton(for button: AuthBottomButton) {
        handleShowLogin()
    }
}

// MARK: - SignUpVCDelegate

extension SignUpVC: SignUpWithEmailVCDelegate {
    func signUpWithVCEmail(_ controller: SignUpWithEmailVC) {
        delegate?.userSignUpVC(self)
    }
}

