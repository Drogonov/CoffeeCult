//
//  ProfileHeader.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit
import Firebase

protocol ProfileHeaderDelegate: class {
    func handleEditProfileTapped()
    func handleEditCompanyTapped()
    func handleTestsTappedVC(for header: ProfileHeader)
    func handleBrewedCupsTappedVC(for header: ProfileHeader)
    
}

enum ProfileHeaderConfiguration {
    case userProfile
    case companyProfile
    
    init() {
        self = .userProfile
    }
}

enum ButtonAction: CustomStringConvertible {
    case userProfile
    case companyProfile
    case createCompanyProfile
    
    var description: String {
        switch self {
        case .userProfile: return "Edit profile"
        case .companyProfile: return "Edit company"
        case .createCompanyProfile: return "Create company"
        }
    }
    
    init() {
        self = .userProfile
    }
}

class ProfileHeader: UIView {
    
    // MARK: - Properties
    
    var buttonAction = ButtonAction()
    var user: User
    var config = ProfileHeaderConfiguration() {
        didSet { configureUI(withConfig: config) }
    }
    weak var delegate: ProfileHeaderDelegate?
    
    let profileImageViewSize: CGFloat = 80
    
    let profileImageView: CustomImageView = {
        let iv = CustomImageView()
        iv.image = UIImage(named: "Znak_logo")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemBackground
        return iv
    }()
    
    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.text = "Chief-barista in Znak Coffee"
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
    
    let averageTestResultLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        
        let attributedText = NSMutableAttributedString(string: "5\n", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "average", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        label.attributedText = attributedText
        return label
    }()
    
    lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .systemBackground
        button.setTitle("Edit profile", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfile), for: .touchUpInside)
        return button
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
        
    // MARK: - Init
    
    init(user: User, frame: CGRect) {
        self.user = user
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 180).isActive = true
        backgroundColor = .secondarySystemBackground
        
        addSubview(profileImageView)
        profileImageView.anchor(top: self.topAnchor,
                                left: self.leftAnchor,
                                paddingTop: 16,
                                paddingLeft: 16,
                                width: profileImageViewSize,
                                height: profileImageViewSize)
        profileImageView.layer.cornerRadius = profileImageViewSize / 2
        
        addSubview(infoLabel)
        infoLabel.anchor(top: profileImageView.bottomAnchor,
                         left: self.leftAnchor,
                         paddingTop: 12,
                         paddingLeft: 16)
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: infoLabel.bottomAnchor,
                                 left: self.leftAnchor,
                                 right: self.rightAnchor,
                                 paddingTop: 12,
                                 paddingLeft: 16,
                                 paddingRight: 16)
//        editProfileButton.centerX(inView: self)
        
        configureGestureRecognizer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleEditProfile() {
        switch buttonAction {
        case .userProfile:
            delegate?.handleEditProfileTapped()
        case .companyProfile:
            delegate?.handleEditCompanyTapped()
        case .createCompanyProfile:
            delegate?.handleEditCompanyTapped()
        }
    }
    
    @objc func handleTestsTapped() {
        delegate?.handleTestsTappedVC(for: self)
    }
    
    @objc func handleCupsTapped() {
        delegate?.handleBrewedCupsTappedVC(for: self)
    }
    
    // MARK: - Helper Functions
    
    func configureUI(withConfig config: ProfileHeaderConfiguration) {
        switch config {
        case .userProfile:
            buttonAction = .userProfile
            editProfileButton.setTitle(buttonAction.description, for: .normal)
            
            let progressStackView = UIStackView(arrangedSubviews: [testsPassedLabel, brewedCupsLabel, averageTestResultLabel])
            progressStackView.axis = .horizontal
            progressStackView.distribution = .fillEqually
            addSubview(progressStackView)
            progressStackView.anchor(left: profileImageView.rightAnchor,
                                     paddingLeft: 12,
                                     height: 50)
            progressStackView.centerY(inView: profileImageView)
            
            addSubview(separatorView)
            separatorView.anchor(left: self.leftAnchor, bottom: self.bottomAnchor,
                                 right: self.rightAnchor, paddingLeft: 8, height: 0.75)
            
            if user.accountType == AccountType(rawValue: 0) {
                infoLabel.text = "Barista in \(user.companyName)"
            } else {
                infoLabel.text = "Chief-barista in \(user.companyName)"
            }
            
            if user.profileImageUrl == "" {
                profileImageView.image = UIImage(named: "User_Icon")
            } else {
                profileImageView.loadImage(with: user.profileImageUrl)
            }
            
        case .companyProfile:
            profileImageView.image = #imageLiteral(resourceName: "Znak_logo")
            infoLabel.text = user.companyName
            
            let progressStackView = UIStackView(arrangedSubviews: [testsPassedLabel, brewedCupsLabel])
            progressStackView.axis = .horizontal
            progressStackView.distribution = .fillEqually
            progressStackView.spacing = 16
            addSubview(progressStackView)
            progressStackView.anchor(left: profileImageView.rightAnchor,
                                     paddingLeft: 12,
                                     height: 50)
            progressStackView.centerY(inView: profileImageView)
            
            if user.companyID == "" {
                buttonAction = .createCompanyProfile
                editProfileButton.setTitle(buttonAction.description, for: .normal)
            } else {
                buttonAction = .companyProfile
                editProfileButton.setTitle(buttonAction.description, for: .normal)
            }
        }
    }
    
    func labelTapped(toLabel label: UILabel, toAction action: Selector) {
        let labelTap = UITapGestureRecognizer(target: self, action: action)
        labelTap.numberOfTapsRequired = 1
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(labelTap)
    }
    
    func configureGestureRecognizer() {
        labelTapped(toLabel: testsPassedLabel, toAction: #selector(handleTestsTapped))
        labelTapped(toLabel: brewedCupsLabel, toAction: #selector(handleCupsTapped))
        labelTapped(toLabel: averageTestResultLabel, toAction: #selector(handleTestsTapped))
    }
    
}
