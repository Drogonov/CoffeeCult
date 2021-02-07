//
//  SignUpWithEmailVC.swift
//  CoffeeCult
//
//  Created by Admin on 04.02.2021.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpWithEmail: UIViewController {
    
    // MARK: - Properties
    
    private lazy var userAuthView = UserAuthWithEmailView()
    private lazy var authBottomButton = AuthBottomButton()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        
    }
}
