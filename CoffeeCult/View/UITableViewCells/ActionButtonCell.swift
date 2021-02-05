//
//  ActionButtonCell.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol ActionButtonCellDelegate: class {
    func handleActionButton(for cell: ActionButtonCell)
}

class ActionButtonCell: UITableViewCell {
    
    // MARK: - Properties
    
    let rowHeight: CGFloat = 74
    
    weak var delegate: ActionButtonCellDelegate?
    
    let updateProfileButton: ActionButton = {
        let button = ActionButton(type: .system)
        button.setTitle("Action Button", for: .normal)
        return button
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selectors
    
    @objc func handleActionButton() {
        delegate?.handleActionButton(for: self)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        contentView.addSubview(updateProfileButton)
        updateProfileButton.anchor(left: self.leftAnchor,
                                   right: self.rightAnchor,
                                   paddingLeft: 40,
                                   paddingRight: 40)
        updateProfileButton.centerX(inView: self)
        updateProfileButton.centerY(inView: self)
        updateProfileButton.addTarget(self, action: #selector(handleActionButton), for: .touchUpInside)
        selectionStyle = .none
    }
}
