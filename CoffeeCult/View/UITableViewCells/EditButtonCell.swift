//
//  EditButtonCell.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol EditButtonCellDelegate: class {
    func handleEditButton(for cell: EditButtonCell)
}

class EditButtonCell: UITableViewCell {
    
    // MARK: - Properties
    
    let rowHeight: CGFloat = 74
    
    weak var delegate: EditButtonCellDelegate?
    
    let editButton: EditButton = {
        let button = EditButton(type: .system)
        button.setTitle("Add barista", for: .normal)
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
    
    @objc func handleEditButton() {
        delegate?.handleEditButton(for: self)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        contentView.addSubview(editButton)
        editButton.anchor(left: self.leftAnchor,
                                   right: self.rightAnchor,
                                   paddingLeft: 16,
                                   paddingRight: 16)
        editButton.centerX(inView: self)
        editButton.centerY(inView: self)
        editButton.addTarget(self, action: #selector(handleEditButton), for: .touchUpInside)
        selectionStyle = .none
        backgroundColor = .secondarySystemBackground
    }
}
