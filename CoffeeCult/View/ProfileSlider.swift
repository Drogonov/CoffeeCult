//
//  ProfileSlider.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol ProfileSliderDelegate: class {
    func handleSliderTapped()
}

class ProfileSlider: UIView {
    
    //MARK:- Properties
    
    weak var delegare: ProfileSliderDelegate?
    
    let sliderImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage().systemImage(withSystemName: "minus")
        iv.tintColor = .label
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    //MARK:- Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = .secondarySystemBackground
        addSubview(sliderImageView)
        sliderImageView.centerX(inView: self)
        sliderImageView.centerY(inView: self)
        configureGestureRecognizer()
        
        addSubview(separatorView)
        separatorView.anchor(left: self.leftAnchor, bottom: self.bottomAnchor,
                             right: self.rightAnchor, paddingLeft: 8, height: 0.75)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Selectors
    
    @objc func handleSliderTapped() {
        delegare?.handleSliderTapped()
    }
    
    //MARK:- Helper Functions
        
    func configureGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleSliderTapped))
        addGestureRecognizer(tap)
    }
}
