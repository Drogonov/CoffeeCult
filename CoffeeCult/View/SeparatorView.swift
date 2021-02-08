//
//  SeparatorView.swift
//  CoffeeCult
//
//  Created by Admin on 07.02.2021.
//

import UIKit

class SeparatorView: UIView {
    
    // MARK: - Properties
    
    lazy var dividerView: UIView = {
        let dividerView = UIView()
        
        let label = UILabel()
        label.text = "OR"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 14)
        dividerView.addSubview(label)
        label.centerX(inView: dividerView)
        label.centerY(inView: dividerView)

        let separator1 = UIView()
        separator1.backgroundColor = .label
        dividerView.addSubview(separator1)
        separator1.anchor(left: dividerView.leftAnchor,
                          right: label.leftAnchor,
                          paddingLeft: 8,
                          paddingRight: 8,
                          height: 1)
        separator1.centerY(inView: dividerView)
        
        let separator2 = UIView()
        separator2.backgroundColor = .label
        dividerView.addSubview(separator2)
        separator2.anchor(left: label.rightAnchor,
                          right: dividerView.rightAnchor,
                          paddingLeft: 8,
                          paddingRight: 8,
                          height: 1)
        separator2.centerY(inView: dividerView)
        
        return dividerView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubview(dividerView)
        dividerView.anchor(top: self.topAnchor,
                           left: self.leftAnchor,
                           bottom: self.bottomAnchor,
                           right: self.rightAnchor,
                           paddingLeft: 32,
                           paddingRight: 32,
                           height: 50)
    }
}


