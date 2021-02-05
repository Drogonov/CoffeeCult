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
    var config = AuthWithButtonConfiguration() {
        didSet { configureUI(withConfig: config) }
    }
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleAuthWithButton() {
        delegate?.handleAuthWithButton(for: self)
    }
    
    func configureUI(withConfig config: AuthWithButtonConfiguration) {
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
        
        switch config {
        case .email:
            authWithButton.backgroundColor = .systemRed
            authWithButton.setTitle("Sign in with Email", for: .normal)
            logoImageView.image = #imageLiteral(resourceName: "mail_white")
        case .google:
            authWithButton.backgroundColor = .white
            authWithButton.setTitleColor(.black, for: .normal)
            authWithButton.setTitle("Sign in with Google", for: .normal)
            logoImageView.image = #imageLiteral(resourceName: "Google_logo")
        case .facebook:
            authWithButton.backgroundColor = .systemBlue
            authWithButton.setTitle("Sign in with Facebook", for: .normal)
            logoImageView.image = #imageLiteral(resourceName: "Facebook_logo")
        case .apple:
            authWithButton.backgroundColor = .black
            authWithButton.setTitle("Sign in with Apple", for: .normal)
            logoImageView.image = #imageLiteral(resourceName: "Apple_logo")
        }
    }
}
