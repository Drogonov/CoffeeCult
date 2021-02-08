//
//  AuthWithButton.swift
//  CoffeeCult
//
//  Created by Admin on 05.02.2021.
//

import UIKit

protocol AuthWithButtonDelegate: class {
    func handleAuthWithButton(for button: AuthWithButton)
}

enum AuthWithButtonConfiguration {
    case email
    case google
    case facebook
    case apple
    
    init() {
        self = .email
    }
}

class AuthWithButton: UIButton {
    
    // MARK: - Properties
    
    weak var delegate: AuthWithButtonDelegate?
    var config = AuthWithButtonConfiguration()
    var viewConfig = UserAuthViewConfiguration()
    
    private let authWithButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 54, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(handleAuthWithButton), for: .touchUpInside)
        button.addShadow()
        return button
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "Apple_logo")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    // MARK: - Init
    
    init(frame: CGRect, config: AuthWithButtonConfiguration, viewConfig: UserAuthViewConfiguration) {
        super.init(frame: frame)
        self.config = config
        self.viewConfig = viewConfig
        configureUI(withConfig: config, withViewConfig: viewConfig)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleAuthWithButton() {
        delegate?.handleAuthWithButton(for: self)
    }
    
    func configureUI(withConfig config: AuthWithButtonConfiguration,
                     withViewConfig viewConfig: UserAuthViewConfiguration) {
        
        addSubview(authWithButton)
        authWithButton.anchor(top: self.topAnchor,
                              left: self.leftAnchor,
                              bottom: self.bottomAnchor,
                              right: self.rightAnchor,
                              paddingLeft: 16,
                              paddingRight: 16)
        
        authWithButton.addSubview(logoImageView)
        logoImageView.anchor(top: authWithButton.topAnchor,
                             left: authWithButton.leftAnchor,
                             bottom: authWithButton.bottomAnchor,
                             paddingTop: 8,
                             paddingLeft: 8,
                             paddingBottom: 8,
                             width: 34)
        
        var titleText: String
        
        switch viewConfig {
        case .login:
            titleText = "Log in"
        case .signUp:
            titleText = "Sign up"
        }
        
        switch config {
        case .email:
            authWithButton.backgroundColor = .systemRed
            authWithButton.setTitle("\(titleText) with Email", for: .normal)
            logoImageView.image = #imageLiteral(resourceName: "mail_white")
        case .google:
            authWithButton.backgroundColor = .white
            authWithButton.setTitleColor(.black, for: .normal)
            authWithButton.setTitle("\(titleText) with Google", for: .normal)
            logoImageView.image = #imageLiteral(resourceName: "Google_logo")
        case .facebook:
            authWithButton.backgroundColor = .systemBlue
            authWithButton.setTitle("\(titleText) with Facebook", for: .normal)
            logoImageView.image = #imageLiteral(resourceName: "Facebook_logo")
        case .apple:
            authWithButton.backgroundColor = .black
            authWithButton.setTitle("\(titleText) with Apple", for: .normal)
            logoImageView.image = #imageLiteral(resourceName: "Apple_logo")
        }
    }
}
