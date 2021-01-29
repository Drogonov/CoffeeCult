//
//  Extensions.swift
//  CoffeeCult
//
//  Created by Admin on 29.01.2021.
//

import UIKit

enum NotificationConfiguration {
    case textField
    case defaultAction
    case rejectAction
    
    init() {
        self = .defaultAction
    }
}

extension UIView {
    
    func inputContainerView(image: UIImage, textField: UITextField? = nil,
                            segmentedControl: UISegmentedControl? = nil) -> UIView {
        let view = UIView()
        
        let imageView = UIImageView()
        imageView.image = image
        imageView.alpha = 0.87
        imageView.tintColor = .label
        view.addSubview(imageView)
        
        
        if let textField = textField {
            imageView.centerY(inView: view)
            imageView.anchor(left: view.leftAnchor, paddingLeft: 8, width: 24, height: 24)
            
            view.addSubview(textField)
            textField.centerY(inView: view)
            textField.anchor(left: imageView.rightAnchor, bottom: view.bottomAnchor,
                             right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        }
        
        if let sc = segmentedControl {
            imageView.anchor(top: view.topAnchor, left: view.leftAnchor,
                             paddingTop: -8, paddingLeft: 8, width: 24, height: 24)
            
            view.addSubview(sc)
            sc.anchor(left: view.leftAnchor, right: view.rightAnchor,
                     paddingLeft: 8, paddingRight: 8)
            sc.centerY(inView: view, constant: 8)
        }
        
        let separatorView = UIView()
        separatorView.backgroundColor = .lightGray
        view.addSubview(separatorView)
        separatorView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                             right: view.rightAnchor, paddingLeft: 8, height: 0.75)
        
        return view
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
}

extension UITextField {
    
    func textField(withPlaceholder placeholder: String, isSecureTextEntry: Bool) -> UITextField {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.textColor = .label
        tf.keyboardAppearance = .dark
        tf.isSecureTextEntry = isSecureTextEntry
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        return tf
    }
    
    private struct AssociatedKeys {
        static var sectionTag: Int?
    }
    
    var sectionTag: Int! {
        get {
            guard let sectionTag = objc_getAssociatedObject(self, &AssociatedKeys.sectionTag) as? Int else {
                return Int()
            }
            return sectionTag
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.sectionTag, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

extension UIImage {
    func systemImage(withSystemName systemName: String) -> UIImage {
        let image = UIImage(systemName: systemName) ?? UIImage(systemName: "questionmark.circle")!
        return image
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showNotification(title: String, message: String? = nil, textField: Bool? = nil, textFieldPlaceholder: String? = nil, textFieldActionText: String? = nil, defaultAction: Bool? = nil, defaultActionText: String? = nil, rejectAction: Bool? = nil, rejectActionText: String? = nil, completion: @escaping(NotificationConfiguration, String?) -> Void) {
        var textInput: String?
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        if textField == true {
            alert.addTextField { (textField) in
                textField.placeholder = textFieldPlaceholder
            }
            alert.addAction(UIAlertAction(title: textFieldActionText, style: .default, handler: { (_) in
                let textField = alert.textFields![0] // Force unwrapping because we know it exists.
                alert.dismiss(animated: true) {
                    print("Text field: \(String(describing: textField.text))")
                    textInput = textField.text?.lowercased()
                    completion(.textField, textInput)
                }
            }))
        }
        if defaultAction == true {
            alert.addAction(UIAlertAction(title: defaultActionText, style: .default, handler: { (_) in
                alert.dismiss(animated: true)
                completion(.defaultAction, textInput)
            }))
        }
        if rejectAction == true {
            alert.addAction(UIAlertAction(title: rejectActionText, style: .destructive, handler: { (_) in
                alert.dismiss(animated: true)
                completion(.rejectAction, textInput)
            }))
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension UIButton {
    private struct AssociatedKeys {
        static var sectionTag: Int?
    }
    var sectionTag: Int! {
        get {
            guard let sectionTag = objc_getAssociatedObject(self, &AssociatedKeys.sectionTag) as? Int else {
                return Int()
            }
            return sectionTag
        }
        set(value) {
            objc_setAssociatedObject(self, &AssociatedKeys.sectionTag, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UITableView {
    
    func registerCells() {
        register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
//        register(SettingsCell.self, forCellReuseIdentifier: Cells.settingsCell)
        register(ProfileCell.self, forCellReuseIdentifier: Cells.profileCell)
//        register(PhotoBtnCell.self, forCellReuseIdentifier: Cells.photoBtnCell)
//        register(TextFieldCell.self, forCellReuseIdentifier: Cells.textFieldCell)
//        register(ActionBtnCell.self, forCellReuseIdentifier: Cells.actionBtnCell)
//        register(EditBtnCell.self, forCellReuseIdentifier: Cells.editBtnCell)
//        register(SegmentedControlCell.self, forCellReuseIdentifier: Cells.segmentedControlCell)
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

