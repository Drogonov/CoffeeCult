//
//  UserAuthView.swift
//  CoffeeCult
//
//  Created by Admin on 04.02.2021.
//

import UIKit

protocol UserAuthViewDelegate: class {
    func handleAuthButton()
}

enum UserAuthViewConfiguration {
    case login
    case signUp
    
    init() {
        self = .login
    }
}

class UserAuthView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: UserAuthViewDelegate?
    var config = UserAuthViewConfiguration() {
        didSet { configureUI(withConfig: config)}
    }
    
    var logoSize: CGFloat = 100
    var logoImageViewWidthConstraint: NSLayoutConstraint!
    var logoImageViewHeightConstraint: NSLayoutConstraint!
    
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
    
    private lazy var passwordContainerView: UIView = {
        let view = UIView().inputContainerView(image: UIImage().systemImage(withSystemName: "lock"), textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = UIView().inputContainerView(image: UIImage().systemImage(withSystemName: "person"), textField: fullnameTextField)
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
    
    let emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email",
                                       isSecureTextEntry: false)
    }()
    
    let passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password",
                                       isSecureTextEntry: true)
    }()
    
    let fullnameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Fullname",
                                       isSecureTextEntry: false)
    }()
    
    let accountTypeSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Barista", "Chief"])
        sc.backgroundColor = .systemBackground
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private let actionButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleActionButton() {
        delegate?.handleAuthButton()
    }
    
    // MARK: - Helper Functions
    
    func configureUI(withConfig config: UserAuthViewConfiguration) {
        configureLogoImage()
        switch config {
        case .login:
            actionButton.setTitle("Log In", for: .normal)
            let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                       passwordContainerView,
                                                       actionButton])
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.spacing = 20
            
            addSubview(stack)
            stack.anchor(top: logoImageView.bottomAnchor, left: self.leftAnchor,
                         right: self.rightAnchor, paddingTop: 40, paddingLeft: 16,
                         paddingRight: 16)
            
        case .signUp:
            actionButton.setTitle("Sign Up", for: .normal)
            let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                       fullnameContainerView,
                                                       passwordContainerView,
                                                       accountTypeContainerView,
                                                       actionButton])
            stack.axis = .vertical
            stack.distribution = .fillEqually
            stack.spacing = 20

            addSubview(stack)
            stack.anchor(top: logoImageView.bottomAnchor, left: self.leftAnchor,
                         right: self.rightAnchor, paddingTop: 40, paddingLeft: 16,
                         paddingRight: 16)
        }
    }
    
    func configureLogoImage() {
        addSubview(logoImageView)
        logoImageView.centerX(inView: self)
        logoImageView.anchor(top: self.topAnchor, paddingTop: 24)
        logoImageViewWidthConstraint = logoImageView.widthAnchor.constraint(equalToConstant: 125)
        logoImageViewWidthConstraint.isActive = true
        logoImageViewHeightConstraint = logoImageView.heightAnchor.constraint(equalToConstant: 125)
        logoImageViewHeightConstraint.isActive = true
    }
}
