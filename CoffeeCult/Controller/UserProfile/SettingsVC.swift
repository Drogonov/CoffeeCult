//
//  SettingsVC.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

import UIKit

class SettingsVC: UIViewController {
    
    // MARK: - Properties
    var user: User
    
    private var settingsTableView = UITableView(frame: CGRect.zero, style: .grouped)
    private let settingsCell = "SettingsCell"
    
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
        
    }
    
    // MARK: - Helper Functions
    
    func configureSettingsTableView() {
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(SettingsCell.self, forCellReuseIdentifier: Cells.settingsCell)
        settingsTableView.rowHeight = 50
        settingsTableView.sectionHeaderHeight = 40
        settingsTableView.sectionFooterHeight = 0
        settingsTableView.backgroundColor = .secondarySystemBackground
        settingsTableView.contentInsetAdjustmentBehavior = .never

        view.addSubview(settingsTableView)
        settingsTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                 left: view.leftAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 right: view.rightAnchor)
        
        settingsTableView.reloadData()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Настройки"
    }
    
    func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        configureNavigationBar()
        configureSettingsTableView()
    }
    
}

// MARK: - TableViewDelegate

extension SettingsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let section = SettingsSection(rawValue: section) else { return 0 }
    
        switch section {
        case .General: return GeneralOptions.allCases.count
        case .Feedback: return FeedbackOptions.allCases.count
        case .PrivacyPolicy: return PrivacyOptions.allCases.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingsSection(rawValue: section)?.description
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.settingsCell, for: indexPath) as! SettingsCell
        cell.backgroundColor = .systemBackground
        cell.delegate = self
        cell.switchControl.tag = indexPath.row
        
        switch section {
        case .General:
            let general = GeneralOptions(rawValue: indexPath.row)
            cell.sectionType = general

        case .Feedback:
            let feedback = FeedbackOptions(rawValue: indexPath.row)
            cell.sectionType = feedback
            
        case .PrivacyPolicy:
            let privacy = PrivacyOptions(rawValue: indexPath.row)
            cell.sectionType = privacy
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .General:
            print(GeneralOptions(rawValue: indexPath.row)?.description ?? 0)
        case .Feedback:
            print(FeedbackOptions(rawValue: indexPath.row)?.description ?? 0)
        case .PrivacyPolicy:
            print(PrivacyOptions(rawValue: indexPath.row)?.description ?? 0)
        }
        settingsTableView.indexPathsForSelectedRows?.forEach {
            settingsTableView.deselectRow(at: $0, animated: true)
        }

    }
}

// MARK: - SettingsCellDelegate

extension SettingsVC: SettingsCellDelegate {
    
    func handleSwitchTapped(sender: UISwitch) {
        let senderSwitch = sender.tag
        
        print("\(sender.tag) # \(sender.isOn)")
        
        if sender.isOn {
            switch senderSwitch {
            case 0: print("Turned of 1")
            case 1: print("Turned of 2")
            case 2: print("Turned of 3")
            case 3: print("Turned of 4")
            default: print("Неизвестный переключатель")
            }
        } else {
            switch senderSwitch {
            case 0: print("Turned on 1")
            case 1: print("Turned on 2")
            case 2: print("Turned on 3")
            case 3: print("Turned on 4")
            default: print("Неизвестный переключатель")
            }
        }
    }
}
