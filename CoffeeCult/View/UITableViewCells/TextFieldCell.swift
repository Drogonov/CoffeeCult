//
//  TextFieldCell.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit

class TextFieldCell: UITableViewCell {
    
    // MARK: - Properties
    
    let rowHeight: CGFloat = 74
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.placeholder = "Enter info here"
        return tf
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        contentView.addSubview(nameTextField)
        nameTextField.anchor(left: self.leftAnchor,
                                 right: self.rightAnchor,
                                 paddingLeft: 40,
                                 paddingRight: 40,
                                 height: 50)
        nameTextField.centerX(inView: self)
        nameTextField.centerY(inView: self)
        selectionStyle = .none
    }
}
