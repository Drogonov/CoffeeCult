//
//  SegmentedControllCell.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol SegmentedControlCellDelegate: class {
    func handleSegmentedControl(for cell: SegmentedControlCell)
}

class SegmentedControlCell: UITableViewCell {
    
    // MARK: - Properties
    
    let rowHeight: CGFloat = 74
    let items = ["Barista", "Chief"]
    weak var delegate: SegmentedControlCellDelegate?
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Barista", "Chief"])
        sc.backgroundColor = .systemBackground
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
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
    
    @objc func handleSegmentedControlChanged() {
        delegate?.handleSegmentedControl(for: self)
    }
    
    // MARK: - Helper Functions
    
    func configureUI() {
                
        contentView.addSubview(segmentedControl)
        segmentedControl.anchor(left: self.leftAnchor,
                                right: self.rightAnchor,
                                paddingLeft: 40,
                                paddingRight: 40,
                                height: 50)
        segmentedControl.centerX(inView: self)
        segmentedControl.centerY(inView: self)
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControlChanged), for: .valueChanged)
        selectionStyle = .none
    }
}
