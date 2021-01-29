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
    
    private var logoSize: CGFloat = 100
    private var logoImageViewWidthConstraint: NSLayoutConstraint!
    private var logoImageViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: LoginVCDelegate?
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "Znak_logo")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "CoffeePRO"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = .label
        return label
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = UIView().inputContainerView(image: UIImage().systemImage(withSystemName: "envelope"), textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: UIImage().systemImage(withSystemName: "lock"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    private let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    private let loginButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.systemRed]))
        
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleLogin() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("DEBUG: Failed to log user in with error \(error.localizedDescription)")
                return
            }
            
//            guard (UIApplication.shared.keyWindow?.rootViewController as? MainTabVC) != nil else { return }
//            controller.configure()
            self.delegate?.userLoginVC(self)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleShowSignUp() {
        let controller = SignUpVC()
        navigationController?.pushViewController(controller, animated: true)
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
        
    func configureUI() {
        configureNavigationBar()
        configureLogoImage()
        view.backgroundColor = .systemBackground
                
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 40, paddingLeft: 16,
                     paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.centerX(inView: view)
        dontHaveAccountButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, height: 32)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
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

