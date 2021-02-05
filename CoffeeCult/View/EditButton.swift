//
//  EditButton.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit

class EditButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 3
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        backgroundColor = .systemBackground
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        setTitleColor(.label, for: .normal)
        heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

