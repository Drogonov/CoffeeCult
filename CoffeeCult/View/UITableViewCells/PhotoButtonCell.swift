//
//  PhotoButtonCell.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol PhotoButtonCellDelegate: class {
    func handleSelectProfilePhotoTapped(for cell: PhotoButtonCell)
}

class PhotoButtonCell: UITableViewCell {
    
    // MARK: - Properties
    
    let rowHeight: CGFloat = 188
    
    
    weak var delegate: PhotoButtonCellDelegate?
    
    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "Plus_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.contentMode = .scaleAspectFit
        
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 140 / 2
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        
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
    
    @objc func handleSelectProfilePhoto() {
        delegate?.handleSelectProfilePhotoTapped(for: self)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
        contentView.addSubview(plusPhotoButton)
        plusPhotoButton.setDimensions(height: 140,
                                   width: 140)
        plusPhotoButton.centerX(inView: self)
        plusPhotoButton.centerY(inView: self)
        plusPhotoButton.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
    }
}
