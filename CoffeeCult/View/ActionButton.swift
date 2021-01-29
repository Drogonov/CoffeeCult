//
//  ActionButton.swift
//  CoffeeCult
//
//  Created by Admin on 29.01.2021.
//

import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
        backgroundColor = .systemRed
        setTitleColor(.white, for: .normal)
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
