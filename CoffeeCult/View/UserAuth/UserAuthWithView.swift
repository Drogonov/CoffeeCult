//
//  UserAuthWithView.swift
//  CoffeeCult
//
//  Created by Admin on 07.02.2021.
//

import UIKit

protocol UserAuthWithViewDelegate: class {
    func handleAuthButton()
}

class UserAuthWithView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: UserAuthWithViewDelegate?
    
    var config = UserAuthViewConfiguration() {
        didSet { configureUI(withConfig: config) }
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
        
        
        
    }
    
}
