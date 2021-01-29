//
//  MainTabVC.swift
//  CoffeeCult
//
//  Created by Admin on 28.01.2021.
//

import UIKit
import Firebase

class MainTabVC: UITabBarController, UITabBarControllerDelegate {
    
    // MARK: - Properties
    

    private var espressoViewController: EspressoVC!
    private var alternativeViewController: AlternativeBrewVC!
//    private var testViewController: TestsVC!
//    private var knowledgeViewController: KnowledgeBaseVC!
//    private var shopViewController: ShopVC!
    
    private var loginVC = LoginVC()
    
    private var user: User? {
        didSet {
            guard let user = user else { return }
            espressoViewController = EspressoVC(user: user)
            espressoViewController.delegate = self
            
            alternativeViewController = AlternativeBrewVC(user: user)
            alternativeViewController.delegate = self
            
//            testViewController = TestsVC(user: user)
//            testViewController.delegate = self
//
//            knowledgeViewController = KnowledgeBaseVC(user: user)
//            shopViewController = ShopVC(user: user)
            
            configureViewControllers()
            print(user.fullname)
        }
    }
    
    // MARK: - Lifecycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        checkIfUserIsLoggedIn()
//        signOut()
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            loginVC.delegate = self
            presentLoginController()
        } else {
            configure()
        }
    }
    
    func fetchUserData() {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: currentUid) { user in
            self.user = user
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("DEBUG: Error signing out")
        }
    }
    
    // MARK: - Helper Functions
    
    func presentLoginController() {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: self.loginVC)
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configure() {
        view.backgroundColor = .systemBackground
        fetchUserData()
    }
    
    // function to create view controllers that exist within tab bar controller
    func configureViewControllers() {
        
        let espressoVC = constructNavController(unselectedImage: UIImage().systemImage(withSystemName: "triangle"),
                                                selectedImage: UIImage().systemImage(withSystemName: "triangle.fill"),
                                                navControllerName: "espresso",
                                                rootViewController: espressoViewController)
        
        let alternativeBrewVC = constructNavController(unselectedImage: UIImage().systemImage(withSystemName: "circle"),
                                                selectedImage: UIImage().systemImage(withSystemName: "circle.fill"),
                                                navControllerName: "brew",
                                                rootViewController: alternativeViewController)
        
//        let testsVC = constructNavController(unselectedImage: UIImage().systemImage(withSystemName: "pencil.circle"),
//                                                selectedImage: UIImage().systemImage(withSystemName: "pencil.circle.fill"),
//                                                navControllerName: "tests",
//                                                rootViewController: testViewController)
//
//        let knowledgeBaseVC = constructNavController(unselectedImage: UIImage().systemImage(withSystemName: "magnifyingglass.circle"),
//                                                selectedImage: UIImage().systemImage(withSystemName: "magnifyingglass.circle.fill"),
//                                                navControllerName: "knowledge",
//                                                rootViewController: knowledgeViewController)
//
//        let shopVC = constructNavController(unselectedImage: UIImage().systemImage(withSystemName: "bag"),
//                                                selectedImage: UIImage().systemImage(withSystemName: "bag.fill"),
//                                                navControllerName: "shop",
//                                                rootViewController: shopViewController)
        
        viewControllers = [espressoVC, alternativeBrewVC]
//        viewControllers = [espressoVC, alternativeBrewVC, testsVC, knowledgeBaseVC, shopVC]
        tabBar.tintColor = .label
        
    }
    
    // construct navigation controllers
    func constructNavController(unselectedImage: UIImage, selectedImage: UIImage, navControllerName: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        navController.tabBarItem.title = navControllerName
        navController.navigationBar.tintColor = .label

        return navController
    }
}




// MARK: - LoginVCDelegate

extension MainTabVC: LoginVCDelegate {
    func userLoginVC(_ controller: LoginVC) {
        configure()
    }
}

// MARK: - EspressoVCDelegate

extension MainTabVC: EspressoVCDelegate {
    func userProfileEditedVC(_ controller: EspressoVC) {
        self.user = controller.user
    }
}

// MARK: - AlternativeBrewVCDelegate

extension MainTabVC: AlternativaBrewVCDelegate {
    func userSignOut(_ controller: AlternativeBrewVC) {
        self.user = controller.user
        signOut()
        checkIfUserIsLoggedIn()
    }
}
