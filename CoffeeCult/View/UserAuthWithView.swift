//
//  UserAuthWithView.swift
//  CoffeeCult
//
//  Created by Admin on 07.02.2021.
//

import UIKit

protocol UserAuthWithViewDelegate: class {
    func handleAuthButton(withConfig config: AuthWithButtonConfiguration)
}

class UserAuthWithView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: UserAuthWithViewDelegate?
    var config = UserAuthViewConfiguration()

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "Znak_logo")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let separator = SeparatorView()
    
    private lazy var authWithEmailButton: AuthWithButton = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        let view = AuthWithButton(frame: frame, config: .email, viewConfig: config)
        return view
    }()
    private lazy var authWithGoogleButton: AuthWithButton = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        let view = AuthWithButton(frame: frame, config: .google, viewConfig: config)
        return view
    }()
    private lazy var authWithFacebookButton: AuthWithButton = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        let view = AuthWithButton(frame: frame, config: .facebook, viewConfig: config)
        return view
    }()
    private lazy var authWithAppleButton: AuthWithButton = {
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 50)
        let view = AuthWithButton(frame: frame, config: .apple, viewConfig: config)
        return view
    }()
        
    // MARK: - Init
    
    init(frame: CGRect, config: UserAuthViewConfiguration) {
        super.init(frame: frame)
        self.config = config
        configureUI(withConfig: config)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    func handleActionButton(withConfig config: AuthWithButtonConfiguration) {
        delegate?.handleAuthButton(withConfig: config)
    }
    
    // MARK: - Helper Functions
    
    func configureUI(withConfig config: UserAuthViewConfiguration) {
        configureAuthWithButtons()
        backgroundColor = .systemBackground
        
        addSubview(logoImageView)
        logoImageView.centerX(inView: self)
        logoImageView.anchor(top: self.topAnchor,
                             paddingTop: 24,
                             width: 125,
                             height: 125)
        
        let stack = UIStackView(arrangedSubviews: [authWithEmailButton,
                                                   separator,
                                                   authWithGoogleButton,
                                                   authWithFacebookButton,
                                                   authWithAppleButton])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor,
                     left: self.leftAnchor,
                     right: self.rightAnchor,
                     paddingTop: 40,
                     paddingLeft: 16,
                     paddingRight: 16)
        
        switch config {
        case .login:
            authWithEmailButton.viewConfig = .login
            authWithGoogleButton.viewConfig = .login
            authWithFacebookButton.viewConfig = .login
            authWithAppleButton.viewConfig = .login
        case .signUp:
            authWithEmailButton.viewConfig = .signUp
            authWithGoogleButton.viewConfig = .signUp
            authWithFacebookButton.viewConfig = .signUp
            authWithAppleButton.viewConfig = .signUp
        }
    }
    
    func configureAuthWithButtons() {
        authWithEmailButton.delegate = self
        authWithGoogleButton.delegate = self
        authWithFacebookButton.delegate = self
        authWithAppleButton.delegate = self
    }
}

extension UserAuthWithView: AuthWithButtonDelegate {
    func handleAuthWithButton(for button: AuthWithButton) {
        handleActionButton(withConfig: button.config)
    }
}
