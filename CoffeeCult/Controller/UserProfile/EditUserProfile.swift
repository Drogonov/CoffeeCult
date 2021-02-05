//
//  EditUserProfile.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit
import Firebase

protocol EditProfileVCDelegate: class {
    func userProfileEditedVC(_ controller: EditProfileVC)
}

class EditProfileVC: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Properties
    
    weak var delegate: EditProfileVCDelegate?
    
    var user: User
    
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    private var refreshControl = UIRefreshControl()
        
    var imageSelected = false
    var imageTapped = false
    var selectedImage = UIImage()
    var userFullnameChanged = false
    var updatedFullname: String?
    var userAccountTypeChanged = false
    var accountTypeIndex: AccountType?
    
    
    var userProfileUpdated = false
    var activeTextField: UITextField?
    
    let alert = UIAlertController(title: nil,
                                  message: "Updating your profile",
                                  preferredStyle: .alert)
    
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
        configureUI()
//        lookForRequestsVC.delegate = self
    }
    
    // MARK: - Selectors
    
    @objc func refresh(_ sender: AnyObject) {
        print("refreshed")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    @objc func Keyboard(notification: Notification) {
    // COMMENT: - This code works pretty strange because if block with activeTextField doesnt affect to how view scrolls up cause it is scrolled only by contentInsets lol. But it works so i fix it later. Maybe.

        if notification.name == UIResponder.keyboardWillHideNotification {
            view.endEditing(true)
            
            let contentInsets = UIEdgeInsets(top: self.tableView.contentInset.top, left: 0, bottom: 0, right: 0)
            self.tableView.contentInset = contentInsets
            self.activeTextField = nil
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                
                let contentInsets = UIEdgeInsets(top: self.tableView.contentInset.top, left: 0, bottom: keyboardSize.height, right: 0)
                self.tableView.contentInset = contentInsets
                var aRect: CGRect = self.view.frame
                aRect.size.height -= keyboardSize.height
                let activeTextFieldRect: CGRect?
                
                if self.activeTextField != nil {
                    print("activeTextField not nil !")
                    activeTextFieldRect = self.activeTextField?.superview?.superview?.frame
                    self.tableView.scrollRectToVisible(activeTextFieldRect!, animated:true)
                }
            }
        }
    }
        
    // MARK: - Helper Functions
    
    func configureUI() {
        configureNavigationBar()
        configureTableView()
        view.backgroundColor = .secondarySystemBackground
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Edit Profile"
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCells()
        
        tableView.sectionHeaderHeight = 40
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = .secondarySystemBackground
        tableView.contentInsetAdjustmentBehavior = .never
        
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                         left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor)
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.reloadData()
        
        self.hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func handleSelectProfilePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func handleUpdateProfile() {

        self.present(alert, animated: true, completion: nil)
        view.endEditing(true)
        
        if imageSelected {
            updateProfileImage()
        }
        if userAccountTypeChanged {
            updateUserAccountType()
        }
        if userFullnameChanged {
            updateUserFullname()
        }
        
        userProfileEdited()
    }
    
    
    // MARK: - API
    
    func updateUserAccountType() {
        
//        let accountTypeIndex = accountTypeSegmentedControl.selectedSegmentIndex
        let selectedAccountTypeIndex = accountTypeIndex?.rawValue ?? user.accountType.rawValue
    
        let values = ["accountType": selectedAccountTypeIndex] as [String : Any]
        
        REF_USERS.child(user.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to update user accountType with error \(error.localizedDescription)")
                return
            }
            
            self.user.accountType = AccountType.init(rawValue: selectedAccountTypeIndex)
        })
        
    }
    
    func updateUserFullname() {
    
        let fullname = updatedFullname ?? self.user.fullname
        
        let values = ["fullname": fullname] as [String : Any]
        
        REF_USERS.child(user.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
            if let error = error {
                print("DEBUG: Failed to update user fullname with error \(error.localizedDescription)")
                return
            }
            
            self.user.fullname = fullname
        })
        
    }
    
    func updateProfileImage() {
        
        let profileImg = selectedImage
        guard let uploadData = profileImg.jpegData(compressionQuality: 0.3) else { return }

        let filename = NSUUID().uuidString
        
        if self.user.profileImageUrl == "" {
            uploadProfileImage(withData: uploadData, withFilename: filename)
        } else {
            deleteImageFromStorage()
            uploadProfileImage(withData: uploadData, withFilename: filename)
        }
        
    }
    
    func uploadProfileImage(withData uploadData: Data, withFilename filename: String) {
        
        let storageRef = Storage.storage().reference().child("profile_images").child(filename)
        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in

            if let error = error {
                print("DEBUG: Failed to upload image to Firebase Storage with error", error.localizedDescription)
                return
            }

            storageRef.downloadURL(completion: { (downloadURL, error) in
                guard let profileImageUrl = downloadURL?.absoluteString else {
                    print("DEBUG: Profile image url is nil")
                    return
                }
                self.user.profileImageUrl = profileImageUrl
                
                DB_REF.child("users/\(self.user.uid)/profileImageUrl").setValue(profileImageUrl) { (error, ref) in
                    if let error = error {
                        print("DEBUG: Failed to update user profile URL in Firebase", error.localizedDescription)
                        return
                    }
                }
            })
        })
    }
    
    func deleteImageFromStorage() {
        let storagePath = user.profileImageUrl
        let desertRef = Storage.storage().reference(forURL: storagePath)
        desertRef.delete { error in
            if let error = error {
                print("DEBUG: Failed to delete image", error.localizedDescription)
                return
            }
        }
    }
    
    
    
    // MARK: - Protocol Functions
    
    func userProfileEdited() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.alert.dismiss(animated: true, completion: {
                self.delegate?.userProfileEditedVC(self)
            })
        }
    }
}

// MARK: - UITableviewDelegate

extension EditProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return EditVCUserSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = EditVCUserSection(rawValue: section) else { return 0 }
        switch section {
        case .EditUser: return section.cellArray.count
        case .Requests: return section.cellArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return EditVCUserSection(rawValue: section)?.description
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = EditVCUserSection(rawValue: indexPath.section) else { return UITableViewCell() }
        let cellType = section.cellType[indexPath.row]

        switch cellType {
        case .editPhotoButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.photoButtonCell, for: indexPath) as! PhotoButtonCell
            tableView.rowHeight = cell.rowHeight
            cell.backgroundColor = .systemBackground
            cell.delegate = self
            cell.plusPhotoButton.tag = indexPath.row
            cell.selectionStyle = .none
            
            if imageTapped == true {
                cell.plusPhotoButton.layer.cornerRadius = cell.plusPhotoButton.frame.width / 2
                cell.plusPhotoButton.layer.masksToBounds = true
                cell.plusPhotoButton.layer.borderColor = UIColor.black.cgColor
                cell.plusPhotoButton.layer.borderWidth = 2
                cell.plusPhotoButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            }
            return cell
            
        case .editNameTF:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            tableView.rowHeight = cell.rowHeight
            cell.backgroundColor = .systemBackground
            cell.nameTextField.placeholder = section.cellArray[indexPath.row]
            cell.nameTextField.tag = indexPath.row
            cell.nameTextField.sectionTag = indexPath.section
            cell.nameTextField.delegate = self
            cell.selectionStyle = .none
            return cell
            
        case .actionButton:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.actionButtonCell, for: indexPath) as! ActionButtonCell
            tableView.rowHeight = cell.rowHeight
            cell.backgroundColor = .systemBackground
            cell.delegate = self
            cell.selectionStyle = .none
            cell.updateProfileButton.tag = indexPath.row
            cell.updateProfileButton.sectionTag = indexPath.section
            cell.updateProfileButton.setTitle(section.cellArray[indexPath.row], for: .normal)
            return cell
            
        case .segmentedControl:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.segmentedControlCell, for: indexPath) as! SegmentedControlCell
            tableView.rowHeight = cell.rowHeight
            cell.backgroundColor = .systemBackground
            cell.delegate = self
            cell.segmentedControl.selectedSegmentIndex = user.accountType.rawValue
            cell.selectionStyle = .none
            return cell
            
        case .textLabel:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell)!
            cell.textLabel?.text = section.cellArray[indexPath.row]
            tableView.rowHeight = 50
            cell.backgroundColor = .systemBackground
            cell.accessoryType = .disclosureIndicator
            return cell
 
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let section = EditVCUserSection(rawValue: indexPath.section) else { return }
        switch section {
        case .EditUser:
            print(section.cellArray[indexPath.row])
        case .Requests:
            print(section.cellArray[indexPath.row])
//            let controller = lookForRequestsVC
//            navigationController?.pushViewController(controller, animated: true)
        }
        
        tableView.indexPathsForSelectedRows?.forEach {
            tableView.deselectRow(at: $0, animated: true)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileVC: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else {
            imageSelected = false
            return
        }
        
        imageSelected = true
        selectedImage = profileImage

        self.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
}

// MARK: - PhotoBtnCellDelegate

extension EditProfileVC: PhotoButtonCellDelegate {
    func handleSelectProfilePhotoTapped(for cell: PhotoButtonCell) {
        print("Photo Selected")
        imageTapped = true
        handleSelectProfilePhoto()
    }
}

// MARK: - ActionBtnCellDelegate

extension EditProfileVC: ActionButtonCellDelegate {
    func handleActionButton(for cell: ActionButtonCell) {
        guard let section = EditVCUserSection(rawValue: cell.updateProfileButton.sectionTag) else { return }
        switch section {
        case .EditUser:
            handleUpdateProfile()
            if userProfileUpdated == true {
                cell.updateProfileButton.isUserInteractionEnabled = false
            }
        case .Requests:
            
            if user.accountType.rawValue == 0 {
                Service.shared.deleteBaristaFromCompany(baristaUID: user.uid) { (err, ref) in
                    if let error = err {
                        print("DEBUG: Failed to delete barista company data with error \(error)")
                        return
                    }
                    self.user.companyID = ""
                    self.user.companyName = "Home Brewery"
                    self.userProfileEdited()
                }
            }
        }
    }
}

// MARK: - SegmentedControlCellDelegate

extension EditProfileVC: SegmentedControlCellDelegate {
    func handleSegmentedControl(for cell: SegmentedControlCell) {
        print("Account changed")
        userAccountTypeChanged = true
        accountTypeIndex = AccountType(rawValue: cell.segmentedControl.selectedSegmentIndex)
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard let text = textField.text else {
            return // nothing to update
        }
        
        guard let section = EditVCUserSection(rawValue: textField.sectionTag) else { return }
        switch section {
        case .EditUser:
            let newUserName = text
            guard self.user.fullname != newUserName else {
                print("ERROR: You did not change you company name")
                userFullnameChanged = false
                return
            }
                
            guard newUserName != "" else {
                print("ERROR: Please enter a valid company name")
                userFullnameChanged = false
                return
            }
            updatedFullname = newUserName
            userFullnameChanged = true
        case .Requests:
            print("Requests TF")
        }
        print("Text: \(text) Section: \(String(describing: textField.sectionTag)) Row: \(textField.tag)")

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        return true
    }
}

//extension EditProfileVC: LookForRequestsDelegate {
//    func userProfileEditedVC(_ controller: LookForRequestsVC) {
//        self.user = controller.user
//        userProfileEdited()
//        configureUI()
//    }
//}
