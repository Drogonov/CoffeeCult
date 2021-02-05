//
//  UserProfile.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit

protocol UserProfileVCDelegate: class {
    func userProfileEditedVC(_ controller: UserProfileVC)
}

class UserProfileVC: UIViewController {
    
    // MARK: - Properties
    
    var user: User
    
//    var cafes = [Cafe]()
//    var barista = [Barista]()
//    var requests = [Request]()
    
    var baristaEmail: String?
    var baristaUID: String?
    var selectedCafeID: String?
    var selectedCafeName: String?

//    private var company: Company? {
//        didSet {
//            guard let company = company else { return }
//            for i in 0..<(company.cafes.count) {
//                if company.cafes != [""] {
//                    Service.shared.fetchCafeData(cafeID: company.cafes[i]) { (cafe) in
//                        self.cafes.insert(cafe, at: 0)
//                        self.cafes = self.cafes.removingDuplicates()
//                        self.cafes = self.cafes.sorted { $0.cafeID < $1.cafeID }
//                        self.tableView.reloadData()
//                    }
//                }
//                if company.companyImageUrl != "" {
//                    companyProfileHeader.profileImageView.loadImage(with: company.companyImageUrl)
//                }
//
//                if user.companyID != "" && user.companyName != company.companyName {
//                    companyNameCheck(companyName: company.companyName)
//                }
//            }
//        }
//    }
    
    private var companyShown : Bool = false
    private var refreshControl = UIRefreshControl()
    
    private let profileHeaderHeight: CGFloat = 180
    private let tableViewHeader = UIView()
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
//    private let shevronSlider = ShevronSlider()
    private let shevronHeight: CGFloat = 30
    
    weak var delegate: UserProfileVCDelegate?
    
    private lazy var userProfileHeader: ProfileHeader = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: profileHeaderHeight)
        let view = ProfileHeader(user: user, frame: frame)
        return view
    }()
//    private lazy var companyProfileHeader: ProfileHeader = {
//        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: userProfileHeaderHeight)
//        let view = UserProfileHeader(user: user, frame: frame)
//        return view
//    }()
    private lazy var editProfileVC = EditProfileVC(user: user)
//    private lazy var editCompanyVC = EditCompanyVC(user: user)
//    private lazy var lookForRequestsVC = LookForRequestsVC(user: user)
    
    // MARK: - Lifecycle

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchCompanyData()
        configureUI()
        editProfileVC.delegate = self
//        editCompanyVC.delegate = self
//        lookForRequestsVC.delegate = self
    }
    
    // MARK: - Selectors
    
    @objc func settingsTapped() {
        let controller = SettingsVC(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        print("refreshed")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
//            self.fetchCompanyData()
            self.tableView.reloadData()
        }
    }
    
    // MARK: - API
    
//    func fetchCompanyData() {
//        if user.companyID != "" {
//            Service.shared.fetchCompanyData(companyID: user.companyID) { company in
//                self.company = company
//            }
//        }
//    }
    
    func connectionCheck(completion: @escaping(Bool) -> Void) {
        Service.shared.connectionCheck { (doesUserConnected) in
            if doesUserConnected == true {
                completion(doesUserConnected)
            } else {
                self.configureNetworkDisconnectedNotification()
                completion(doesUserConnected)
            }
        }
    }
    
    func companyNameCheck(companyName: String) {
        Service.shared.changeUserValue(userID: user.uid, config: .companyName, value: companyName) { (err, ref) in
            if let error = err {
                print("DEBUG: Failed to upload company name to user with error \(error)")
                return
            }
            self.user.companyName = companyName
            self.userProfileEdited()
        }
    }
    
    // MARK: - Barista API
    
//    func lookForTheRequest() {
//        BaristaService.shared.lookForTheRequest(email: user.email) { (_) in
//            self.configureBaristaGotRequestNotification()
//        }
//    }
    
    // MARK: - Chief API
    
//    func sendRequestToBarista() {
//        guard let baristaEmailString = baristaEmail else { return }
//        guard let selectedCafeIDString = selectedCafeID else { return }
//        connectionCheck { (doesUserConnected) in
//            if doesUserConnected == true {
//                self.checkIfUserExistByEmail(baristaEmail: baristaEmailString) { (baristaExist) in
//                    if baristaExist == true {
//                        print("baristaExist")
//                        self.doesBaristaGetRequest(baristaEmail: baristaEmailString) { (requestSended) in
//                            if requestSended == false {
//                                print("barista havent a request")
//                                guard let baristaUIDString = self.baristaUID else { return }
//                                self.doesBaristaAlreadyAdded(baristaUID: baristaUIDString) { (doesBaristaAdded) in
//                                    if doesBaristaAdded == false {
//                                        self.uploadRequest(baristaEmail: baristaEmailString,
//                                                           selectedCafeID: selectedCafeIDString,
//                                                           baristaUID: baristaUIDString)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    func checkIfUserExistByEmail(baristaEmail: String, completion: @escaping(Bool) -> Void) {
//        ChiefService.shared.checkIfUserExistByEmail(email: baristaEmail) { (baristaExist, baristaUID) in
//            if baristaExist == true {
//                self.baristaUID = baristaUID
//                completion(baristaExist)
//            } else {
//                self.configureBaristaDoesntExistNotification()
//                completion(baristaExist)
//            }
//        }
//    }
//
//    func doesBaristaGetRequest(baristaEmail: String, completion: @escaping(Bool) -> Void) {
//        ChiefService.shared.doesBaristaGetRequest(email: baristaEmail,
//                                                  user: self.user) { (requestSended) in
//            print("requestSended = \(requestSended)")
//            if requestSended == true {
//                self.configureRequestAlreadySendedNotification()
//                completion(requestSended)
//            } else {
//                completion(requestSended)
//            }
//        }
//    }
//
//    func uploadRequest(baristaEmail: String, selectedCafeID: String, baristaUID: String) {
//        ChiefService.shared.uploadRequest(emailChief: self.user.email,
//                                          emailBarista: baristaEmail,
//                                          chiefUID: self.user.uid,
//                                          cafeID: selectedCafeID,
//                                          companyID: self.user.companyID,
//                                          baristaUID: baristaUID) { (err, ref, requestID)in
//            if let error = err {
//                self.configureErrorNotification()
//                print("DEBUG: Failed to upload barista request with error \(error)")
//                return
//            }
//            ChiefService.shared.uploadBaristaToCafe(cafeID: selectedCafeID,
//                                                    baristaUID: baristaUID) { (err, ref) in
//                if let error = err {
//                    self.configureErrorNotification()
//                    Service.shared.deleteRequest(requestID: requestID) { (err, ref) in
//                        if let error = err {
//                            print("DEBUG: Failed to delete request with error \(error)")
//                            return
//                        }
//                    }
//                    print("DEBUG: Failed to upload barista request to cafe with error \(error)")
//                    return
//                }
//                self.configureRequestSendedNotification()
//            }
//        }
//    }
//
//    func deleteBaristaFromCompany(baristaUID: String, cafeID: String, baristaID: String, section: Int, completion: @escaping() -> Void) {
//        Service.shared.deleteBaristaFromCompany(baristaUID: baristaUID) { (err, ref) in
//            if let error = err {
//                print("DEBUG: Failed to delete barista company data with error \(error)")
//                return
//            }
//            Service.shared.deleteBaristaFromCafe(cafeID: cafeID, baristaID: baristaID) { (err, ref) in
//                if let error = err {
//                    print("DEBUG: Failed to delete barista from cafe with error \(error)")
//                    return
//                }
//                self.cafes[section].baristaArray.removeAll { (barista) -> Bool in
//                    return barista.baristaUID == baristaUID
//                }
//                completion()
//            }
//        }
//    }
//
//    func doesBaristaQuitFromCompany(barista: User, baristaID: String, cafeID: String) {
//        if barista.companyID == "" || barista.companyID != user.companyID {
//            Service.shared.deleteBaristaFromCafe(cafeID: cafeID, baristaID: baristaID) { (err, ref) in
//                if let error = err {
//                    print("DEBUG: Failed to delete barista from cafe with error \(error)")
//                    return
//                }
//            }
//        }
//    }
    
    // MARK: - Helper Functions
    
    func configureNavigationBar() {
        navigationItem.title = user.fullname
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage().systemImage(withSystemName: "gear"), style: .plain, target: self, action: #selector(settingsTapped))
    }
    
    func configureUI() {
        if user.accountType == .chief {
            configureNavigationBar()
//            configureTableView()
        } else {
            configureNavigationBar()
            configureUserProfileHeader()
//            lookForTheRequest()
        }
 
        view.backgroundColor = .secondarySystemBackground
    }
    
    func configureNetworkDisconnectedNotification() {
        showNotification(title: "Кажется у вас проблемы с сетью",
                         message: "Подключен ли интернет?",
                         defaultAction: true,
                         defaultActionText: "OK") { (config, _) in
            switch config {
            default: break
            }
        }
    }
    
// MARK: - Barista Helper Functions
    
    func configureUserProfileHeader() {
        userProfileHeader.delegate = self
        userProfileHeader.config = .userProfile
        
        view.addSubview(userProfileHeader)
        userProfileHeader.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 left: view.leftAnchor,
                                 right: view.rightAnchor,
                                 height: profileHeaderHeight)
    }
    
//    func configureBaristaGotRequestNotification() {
//        showNotification(title: "Вас приглашают в кофейню",
//                         defaultAction: true,
//                         defaultActionText: "Открыть",
//                         rejectAction: true,
//                         rejectActionText: "Отмена") { (config, _) in
//            switch config {
//            case .defaultAction:
//                let controller = self.lookForRequestsVC
//                self.navigationController?.pushViewController(controller, animated: true)
//            default: break
//            }
//        }
//    }
    
// MARK: - Chief Helper Functions
    
//    func configureTableView() {
//
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.registerCells()
//
//        tableView.sectionHeaderHeight = 40
//        tableView.sectionFooterHeight = 50
//        tableView.backgroundColor = .secondarySystemBackground
//        tableView.contentInsetAdjustmentBehavior = .never
//
//        view.addSubview(tableView)
//        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
//                         left: view.leftAnchor,
//                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
//                         right: view.rightAnchor)
//
//        tableView.frame = view.frame
//
//        let paddingTop = paddingTopCalc()
//        let frame = CGRect(x: 0, y: paddingTop, width: view.frame.width, height: profileHeaderHeight+shevronHeight)
//
//        print(view.frame.width)
//        tableViewHeader.frame = frame
//        tableView.tableHeaderView = tableViewHeader
//
//        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
//        tableView.addSubview(refreshControl)
//
//        companyProfileHeader.delegate = self
//        companyProfileHeader.config = .companyProfile
//
//        tableViewHeader.addSubview(companyProfileHeader)
//
//        shevronSlider.delegare = self
//        tableViewHeader.addSubview(shevronSlider)
//        shevronSlider.anchor(top: companyProfileHeader.bottomAnchor,
//                             left: tableViewHeader.leftAnchor,
//                             right: tableViewHeader.rightAnchor,
//                             height: shevronHeight)
//
//        userProfileHeader.delegate = self
//        userProfileHeader.config = .userProfile
//        tableViewHeader.addSubview(userProfileHeader)
//
//        tableView.reloadData()
//    }
//
//    func animateCompanyProfileHeader(shouldShow: Bool) {
//
//        let paddingTop = paddingTopCalc()
//        let yOrigin = shouldShow ? self.profileHeaderHeight : 0
//        let yOrigin2 = self.profileHeaderHeight + yOrigin
//
//        let tableViewHeight = shouldShow ? self.profileHeaderHeight*2 + self.shevronHeight : self.profileHeaderHeight + self.shevronHeight
//        let tableHeaderView = tableView.tableHeaderView
//        let frame = CGRect(x: 0, y: paddingTop, width: view.frame.width, height: tableViewHeight)
//
//        UIView.animate(withDuration: 0.3, animations: {
//            tableHeaderView?.frame = frame
//            self.tableView.tableHeaderView = tableHeaderView
//
//            self.companyProfileHeader.frame.origin.y = CGFloat(yOrigin)
//            self.shevronSlider.frame.origin.y = CGFloat(yOrigin2)
//
//            self.view.layoutIfNeeded()
//        })
//    }
//
//    func paddingTopCalc() -> CGFloat {
//        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
//        let navBarHeight = navigationController?.navigationBar.frame.height ?? 0
//        let paddingTop = statusBarHeight + navBarHeight
//
//        return paddingTop
//    }
//
//    func filterCafesByStatus(section: Int, status: Int) -> [Barista] {
//        var filtered = cafes[section].baristaArray.filter { (barista) -> Bool in
//            return barista.status == status
//        }
//        filtered = filtered.sorted { $0.baristaID < $1.baristaID }
//        return filtered
//    }
//
//    func configureBaristaTextFieldNotification() {
//        guard let selectedCafeName = selectedCafeName else { return }
//        showNotification(title: "Добавить бариста в кафе?",
//                         message: selectedCafeName,
//                         textField: true,
//                         textFieldPlaceholder: "Введите почту бариста",
//                         textFieldActionText: "Отправить",
//                         rejectAction: true,
//                         rejectActionText: "Отмена") { (config, inputText) in
//            switch config {
//            case .textField:
//                self.baristaEmail = inputText
//                self.sendRequestToBarista()
//            default: break
//            }
//        }
//    }
//
//    func configureRequestAlreadySendedNotification() {
//        showNotification(title: "Вы уже отправляли запрос этому пользователю",
//                         defaultAction: true,
//                         defaultActionText: "OK") { (config, _) in
//            switch config {
//            default: break
//            }
//        }
//    }
//
//    func configureRequestSendedNotification() {
//        showNotification(title: "Запрос успешно отправлен",
//                         message: "Скоро он появится в отправленных приглашениях",
//                         defaultAction: true,
//                         defaultActionText: "OK") { (config, _) in
//            switch config {
//            default: break
//            }
//        }
//    }
//
//    func configureBaristaDoesntExistNotification() {
//        showNotification(title: "Такого пользователя не существует",
//                         message: "Попробуйте еще раз",
//                         defaultAction: true,
//                         defaultActionText: "OK") { (config, _) in
//            switch config {
//            default: break
//            }
//        }
//    }
//
//    func configureBaristaAlreadyAddedNotification(baristasCafeName: String) {
//        showNotification(title: "Данный пользователь уже работает в кофейне \(baristasCafeName)",
//                         message: "Если хотите его переместить, зайдите в его карточку",
//                         defaultAction: true,
//                         defaultActionText: "OK") { (config, _) in
//            switch config {
//            default: break
//            }
//        }
//    }
//
//    func configureDeleteBaristaNotification(baristaUID: String, cafeID: String, baristaID: String, section: Int) {
//        showNotification(title: "Вы уверены, что хотите удалить данного пользователя?",
//                         defaultAction: true,
//                         defaultActionText: "Да",
//                         rejectAction: true,
//                         rejectActionText: "Отмена") { (config, _) in
//            switch config {
//            case .defaultAction:
//                self.deleteBaristaFromCompany(baristaUID: baristaUID, cafeID: cafeID, baristaID: baristaID, section: section) {
//                    self.tableView.reloadData()
//                }
//            default: break
//            }
//        }
//    }
//
//    func configureErrorNotification() {
//        showNotification(title: "Что-то пошло не так",
//                         message: "Попробуйте еще раз",
//                         defaultAction: true,
//                         defaultActionText: "OK") { (config, _) in
//            switch config {
//            default: break
//            }
//        }
//    }
//
//    func doesBaristaAlreadyAdded(baristaUID: String, completion: @escaping(Bool) -> Void) {
//        var doesBaristaAdded = false
//
//        for i in 0..<cafes.count {
//            for y in 0..<cafes[i].baristaArray.count {
//                if cafes[i].baristaArray[y].baristaUID == baristaUID && cafes[i].baristaArray[y].status == 1 {
//                    doesBaristaAdded = true
//                    self.configureBaristaAlreadyAddedNotification(baristasCafeName: cafes[i].cafeName)
//                }
//            }
//        }
//        completion(doesBaristaAdded)
//    }
    
// MARK: - Protocol Functions
    
    func userProfileEdited() {
        delegate?.userProfileEditedVC(self)
    }

}

// MARK: - TableViewDelegate

//extension UserProfileVC: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if user.companyID == "" {
//            return 1
//        }
//        return cafes.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if user.companyID == "" || cafes[section].baristaID == [""] {
//            return 0
//        }
//
//        return filterCafesByStatus(section: section, status: 1).count
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if user.companyID == "" {
//            return "Вы еще не создали компанию"
//        }
//        return cafes[section].cafeName
//    }
//
//
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if user.companyID == "" {
//            tableView.sectionFooterHeight = 0
//            return UIView()
//        }
//
//        let footerCell = tableView.dequeueReusableCell(withIdentifier: Cells.editBtnCell) as! EditButtonCell
//        footerCell.delegate = self
//        footerCell.tag = section
//        return footerCell
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.baristaProfileCell, for: indexPath) as! ProfileCell
//        cell.backgroundColor = .systemBackground
//
//        if cafes[indexPath.section].baristaID != [""] {
//            let filtered = filterCafesByStatus(section: indexPath.section, status: 1)
//            Service.shared.fetchUserData(uid: filtered[indexPath.row].baristaUID) { (barista) in
//                cell.baristaNameLabel.text = barista.fullname
//                cell.profileImageView.loadImage(with: barista.profileImageUrl)
//                self.doesBaristaQuitFromCompany(barista: barista,
//                                                baristaID: filtered[indexPath.row].baristaID,
//                                                cafeID: self.cafes[indexPath.section].cafeID)
//            }
//        }
//
//        cell.config = .profile
//        tableView.rowHeight = cell.rowHeight
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let filtered = filterCafesByStatus(section: indexPath.section, status: 1)
//        print(filtered[indexPath.row].baristaUID)
//
//        tableView.indexPathsForSelectedRows?.forEach {
//            tableView.deselectRow(at: $0, animated: true)
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completion) in
//            let filtered = self.filterCafesByStatus(section: indexPath.section, status: 1)
//
//            self.configureDeleteBaristaNotification(baristaUID: filtered[indexPath.row].baristaUID,
//                                                    cafeID: self.cafes[indexPath.section].cafeID,
//                                                    baristaID: filtered[indexPath.row].baristaID,
//                                                    section: indexPath.section)
//        }
//        deleteAction.image = UIImage(systemName: "trash")
//        deleteAction.backgroundColor = .systemRed
//        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
//        return configuration
//    }
//
//}

// MARK: - ProfileHeaderDelegate

extension UserProfileVC: ProfileHeaderDelegate {
        
    func handleEditProfileTapped() {
        let controller = editProfileVC
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleEditCompanyTapped() {
//        let controller = editCompanyVC
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleTestsTappedVC(for header: ProfileHeader) {
//        let controller = TestsResultsVC()
//        navigationController?.pushViewController(controller, animated: true)
    }
    
    func handleBrewedCupsTappedVC(for header: ProfileHeader) {
//        let controller = BrewedCupsVC()
//        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - EditProfileVCDelegate

extension UserProfileVC: EditProfileVCDelegate {
    func userProfileEditedVC(_ controller: EditProfileVC) {
        self.user = controller.user
        userProfileEdited()
        configureUI()
    }
}

// MARK: - EditCompanyVCDelegate

//extension UserProfileVC: EditCompanyVCDelegate {
//    func userCompanyEditedVC(_ controller: EditCompanyVC) {
//        self.user = controller.user
//        userProfileEdited()
//        configureUI()
//    }
//}

// MARK:- ShevronSliderDelegate

//extension UserProfileVC: ShevronSliderDelegate {
//
//    func handleShevronTapped() {
//
//        if companyShown == false {
//            animateCompanyProfileHeader(shouldShow: true)
//            companyShown = true
//        } else {
//            animateCompanyProfileHeader(shouldShow: false)
//            companyShown = false
//        }
//    }
//}
//
//extension UserProfileVC: LookForRequestsDelegate {
//    func userProfileEditedVC(_ controller: LookForRequestsVC) {
//        self.user = controller.user
//        userProfileEdited()
//        configureUI()
//    }
//}

//extension UserProfileVC: EditButtonCellDelegate {
//    func handleEditButton(for cell: EditButtonCell) {
//        tableView.reloadData()
//        selectedCafeID = cafes[cell.tag].cafeID
//        selectedCafeName = cafes[cell.tag].cafeName
//        configureBaristaTextFieldNotification()
//    }
//}
