//
//  ProfileCell.swift
//  CoffeeCult
//
//  Created by Admin on 29.01.2021.
//

import UIKit

enum ProfileCellConfiguration {
    case profile
    case request
    
    init() {
        self = .profile
    }
}

class ProfileCell: UITableViewCell {
    
    // MARK: - Properties
        
    let profileImageViewSize: CGFloat = 60
    let rowHeight: CGFloat = 80
    
    var config = ProfileCellConfiguration() {
        didSet { configureUI(withConfig: config) }
    }
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = UIImage(named: "User_Icon")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .secondarySystemBackground
        return iv
    }()
    
    var baristaNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Barista Name"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    var requestLabel: UILabel = {
        let label = UILabel()
        label.text = "Request"
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let testsPassedLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "tests", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        return label
    }()
    
    let brewedCupsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "cups", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        return label
    }()
    
    let averageTestResult: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "average", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        configureBaristaCell()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    //MARK: - Helper Functions
    
    func configureBaristaCell() {
        profileImageView.setDimensions(height: profileImageViewSize, width: profileImageViewSize)
        profileImageView.layer.cornerRadius = profileImageViewSize / 2
        
        let progressStackView = UIStackView(arrangedSubviews: [testsPassedLabel, brewedCupsLabel, averageTestResult])
        progressStackView.axis = .horizontal
        progressStackView.distribution = .fillEqually
        
        let infoStack = UIStackView(arrangedSubviews: [baristaNameLabel, progressStackView])
        infoStack.axis = .vertical
        infoStack.distribution = .fillProportionally
        
        let cellStack = UIStackView(arrangedSubviews: [profileImageView, infoStack])
        cellStack.axis = .horizontal
        cellStack.spacing = 8
        
        addSubview(cellStack)
        cellStack.anchor(left: self.leftAnchor, paddingLeft: 8)
        cellStack.centerY(inView: self)

    }
    
    func configureAddBaristaCell() {
        textLabel?.text = "Добавить бариста"
        accessoryType = .disclosureIndicator
    }
    
    func configureUI(withConfig config: ProfileCellConfiguration) {
        switch config {
        case .profile:
            profileImageView.setDimensions(height: profileImageViewSize, width: profileImageViewSize)
            profileImageView.layer.cornerRadius = profileImageViewSize / 2
            baristaNameLabel.textAlignment = .center
            
            let progressStackView = UIStackView(arrangedSubviews: [testsPassedLabel, brewedCupsLabel, averageTestResult])
            progressStackView.axis = .horizontal
            progressStackView.distribution = .fillEqually
            
            let infoStack = UIStackView(arrangedSubviews: [baristaNameLabel, progressStackView])
            infoStack.axis = .vertical
            infoStack.distribution = .fillProportionally
            
            let cellStack = UIStackView(arrangedSubviews: [profileImageView, infoStack])
            cellStack.axis = .horizontal
            cellStack.spacing = 8
            
            addSubview(cellStack)
            cellStack.anchor(left: self.leftAnchor, paddingLeft: 8)
            cellStack.centerY(inView: self)
        case .request:
            profileImageView.setDimensions(height: profileImageViewSize, width: profileImageViewSize)
            profileImageView.layer.cornerRadius = profileImageViewSize / 2
            
            let infoStack = UIStackView(arrangedSubviews: [baristaNameLabel, requestLabel])
            infoStack.axis = .vertical
            infoStack.distribution = .fillEqually
            
            let cellStack = UIStackView(arrangedSubviews: [profileImageView, infoStack])
            cellStack.axis = .horizontal
            cellStack.spacing = 8
            
            addSubview(cellStack)
            cellStack.anchor(left: self.leftAnchor, paddingLeft: 8)
            cellStack.centerY(inView: self)
        
        }
    }
}

