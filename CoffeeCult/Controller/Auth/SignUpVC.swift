//
//  SignUpVC.swift
//  CoffeeCult
//
//  Created by Admin on 29.01.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpVC: UIViewController {
    
    // MARK: - Properties
    
    private var logoSize: CGFloat = 100
    private var logoImageViewWidthConstraint: NSLayoutConstraint!
    private var logoImageViewHeightConstraint: NSLayoutConstraint!
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "Znak_logo")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: UIImage().systemImage(withSystemName: "envelope"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = UIView().inputContainerView(image: UIImage().systemImage(withSystemName: "person"), textField: fullnameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: UIImage().systemImage(withSystemName: "lock"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var accountTypeContainerView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        view.addSubview(accountTypeSegmentedControl)
        accountTypeSegmentedControl.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                                           paddingLeft: 8, paddingRight: 8)
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                             right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    private let fullnameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Fullname",
                                       isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    private let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Barista", "Chief"])
        sc.backgroundColor = .systemBackground
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let signUpButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.systemRed]))
        
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleSignUp() {
        guard let email = emailTextField.text?.localizedLowercase.trimmingCharacters(in: .whitespaces) else { return }
        guard let password = passwordTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        guard let fullname = fullnameTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
                
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to register user with error \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email,
                          "fullname": fullname,
                          "accountType": accountTypeIndex] as [String : Any]
            
            self.uploadUserDataAndShowHomeController(uid: uid, values: values)
        }
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func Keyboard(notification: Notification) {

        if notification.name == UIResponder.keyboardWillHideNotification {
            logoSize = 125
            UIView.animate(withDuration: 0.5, animations: {
                self.logoImageViewHeightConstraint.constant = self.logoSize
                self.logoImageViewWidthConstraint.constant = self.logoSize
            })
        } else {
            logoSize = 70
            UIView.animate(withDuration: 0.5, animations: {
                self.logoImageViewHeightConstraint.constant = self.logoSize
                self.logoImageViewWidthConstraint.constant = self.logoSize
              })
        }
        view.layoutIfNeeded()
    }
    
    // MARK: - Helper Functions
    
    func uploadUserDataAndShowHomeController(uid: String, values: [String: Any]) {
        REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
//            guard (UIApplication.shared.keyWindow?.rootViewController as? MainTabVC) != nil else { return }
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        configureLogoImage()
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   fullnameContainerView,
                                                   passwordContainerView,
                                                   accountTypeContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually

        stack.spacing = 20

        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 40, paddingLeft: 16,
                     paddingRight: 16)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.centerX(inView: view)
        alreadyHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
    func configureLogoImage() {
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view)
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 24)
        
        logoImageViewWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 125)
        logoImageViewWidthConstraint.isActive = true
        logoImageViewHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 125)
        logoImageViewHeightConstraint.isActive = true
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
}

