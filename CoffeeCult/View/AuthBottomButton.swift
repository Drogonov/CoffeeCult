//
//  AuthBottomButton.swift
//  CoffeeCult
//
//  Created by Admin on 04.02.2021.
//

import UIKit

protocol AuthBottomButtonDelegate: class {
    func handleAuthBottomButton(for button: AuthBottomButton)
}

enum AuthBottomButtonConfiguration {
    case login
    case signUp
    case comeBack
    
    init() {
        self = .login
    }
}

class AuthBottomButton: UIButton {
    
    // MARK: - Properties
    
    weak var delegate: AuthBottomButtonDelegate?
    var config = AuthBottomButtonConfiguration() {
        didSet { configureUI(withConfig: config) }
    }
    let authBottomButton: UIButton = {
        let button = UIButton(type: .system)
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
    
    @objc func handleAuthBottomButton() {
        delegate?.handleAuthBottomButton(for: self)
    }
    
    // MARK: - Helper Functions
    
    func configureUI(withConfig config: AuthBottomButtonConfiguration) {
        addSubview(authBottomButton)
        authBottomButton.anchor(left: self.leftAnchor,
                                bottom: self.bottomAnchor,
                                right: self.rightAnchor,
                                height: 32)
        authBottomButton.addTarget(self, action: #selector(handleAuthBottomButton), for: .touchUpInside)
        
        switch config {
        case .login:
            configureButtonTitle(title1: "Don't have an account?  ",
                                 title2: "Sign Up")
        case .signUp:
            configureButtonTitle(title1: "Already have an account?  ",
                                 title2: "Log In")
        case .comeBack:
            configureButtonTitle(title1: "Whant other option?  ",
                                 title2: "Come back")
        }
    }
    
    func configureButtonTitle(title1: String, title2: String) {
        let attributedTitle = NSMutableAttributedString(string: title1, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: title2, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.systemRed]))
        authBottomButton.setAttributedTitle(attributedTitle, for: .normal)
    }
}
