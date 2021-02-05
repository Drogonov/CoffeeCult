//
//  SettingsCell.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol SettingsCellDelegate {
    func handleSwitchTapped(sender: UISwitch)
}

class SettingsCell: UITableViewCell {
    
    // MARK: - Properties
    
    var delegate: SettingsCellDelegate?
    
    var sectionType: SectionType? {
        didSet {
            guard let sectionType = sectionType else { return }
            textLabel?.text = sectionType.description
            switchControl.isHidden = !sectionType.containsSwitch
                        
            if sectionType.containsAccessory == true {
                accessoryType = .disclosureIndicator
            } else {
                accessoryType = .none
            }
        }
    }
    
    lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = true
        switchControl.onTintColor = UIColor.systemGreen
        switchControl.addTarget(self, action: #selector(handleSwitchAction), for: .valueChanged)
        switchControl.isUserInteractionEnabled = true
        return switchControl
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(switchControl)
        switchControl.centerY(inView: self)
        switchControl.anchor(right: self.rightAnchor, paddingRight: 12)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleSwitchAction(sender: UISwitch) {
        delegate?.handleSwitchTapped(sender: switchControl)
    }
    
}
