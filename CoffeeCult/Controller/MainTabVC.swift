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
   
    let defaults = UserDefaults.standard

    private var espressoViewController: EspressoVC!
    private var alternativeViewController: AlternativeBrewVC!
//    private var testViewController: TestsVC!
//    private var knowledgeViewController: KnowledgeBaseVC!
//    private var shopViewController: ShopVC!
    
    private var loadingVC = LoadingViewController()
    private var loadingView = LoadingView()
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
        configureUI()
        checkIfUserIsLoggedIn { (wasLoadingVCShown) in
            if wasLoadingVCShown == true {
                self.dismissLoadingView()
            }
        }
    }
    
    // MARK: - Selectors
    
    // MARK: - API
    
    func checkIfUserIsLoggedIn(completion: @escaping(Bool) -> Void) {
        var wasLoadingVCShown = true
            if self.defaults.bool(forKey: SettingsKeys.isUserNotFirstLogin.rawValue) == false {
                showLoadingView()
                if Auth.auth().currentUser?.uid == nil {
                    self.loginVC.delegate = self
                    self.presentLoginController {
                        print("Auth checkIfUserIsLoggedIn isUserNotFirstLogin == \(self.defaults.bool(forKey: SettingsKeys.isUserNotFirstLogin.rawValue))")
                        completion(wasLoadingVCShown)
                    }
                } else {
                    self.fetchUserData {
                        self.defaults.setValue(true, forKey: SettingsKeys.isUserNotFirstLogin.rawValue)
                        print("FetchUserData checkIfUserIsLoggedIn isUserNotFirstLogin == \(self.defaults.bool(forKey: SettingsKeys.isUserNotFirstLogin.rawValue))")
                        completion(wasLoadingVCShown)
                    }
                }
            } else {
                wasLoadingVCShown = false
                self.fetchUserRealmData {
                    print("Realm checkIfUserIsLoggedIn isUserNotFirstLogin == \(self.defaults.bool(forKey: SettingsKeys.isUserNotFirstLogin.rawValue))")
                    completion(wasLoadingVCShown)
                }
            }
    }
    
    func fetchUserData(completion: @escaping() -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Service.shared.fetchUserData(uid: currentUid) { user in
            self.user = user
            RealmService.shared.add(user)
            completion()
        }
    }
    
    func fetchUserRealmData(completion: @escaping() -> Void) {
        let results = RealmService.shared.allObjectValues(User.self)
        self.user = Array(results).first
        completion()
    }
    
    func signOut(completion: @escaping() -> Void) {
        do {
            try Auth.auth().signOut()
            self.defaults.setValue(false, forKey: SettingsKeys.isUserNotFirstLogin.rawValue)
            RealmService.shared.deleteAll()
            print("signOut isUserNotFirstLogin == \(self.defaults.bool(forKey: SettingsKeys.isUserNotFirstLogin.rawValue))")
            completion()
        } catch {
            print("DEBUG: Error signing out")
            completion()
        }
    }
    
    // MARK: - Helper Functions
    
    func presentLoginController(completion: @escaping() -> Void) {
        DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: self.loginVC)
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: completion)
        }
    }
    
    func showLoadingView() {
        UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.addSubview(loadingView)
        loadingView.frame = view.frame
        UIView.animate(withDuration: 0.1, animations: {
            self.loadingView.alpha = 1
        })
    }
    
    func dismissLoadingView(completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.loadingView.alpha = 0
            self.loadingView.removeFromSuperview()
        }, completion: completion)
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
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
        checkIfUserIsLoggedIn { (wasLoadingVCShown) in
            if wasLoadingVCShown == true {
                self.dismissLoadingView()
            }
        }
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
        signOut {
            self.checkIfUserIsLoggedIn { (wasLoadingVCShown) in
                if wasLoadingVCShown == true {
                    self.loadingVC.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
