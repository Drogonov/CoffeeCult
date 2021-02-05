//
//  SettingsModel.swift
//  CoffeeCult
//
//  Created by Admin on 01.02.2021.
//

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
    var containsAccessory: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible {
    case General
    case Feedback
    case PrivacyPolicy
    
    var description: String {
        switch self {
        case .General: return "Общие"
        case .Feedback: return "Обратная связь"
        case .PrivacyPolicy: return "Приватность"
        }
    }
}

enum GeneralOptions: Int, CaseIterable, SectionType {
    case muteSound
    case temperature
    case mass
    case bluetoothScales
    
    var containsSwitch: Bool {
        switch self {
        case .muteSound: return true
        case .temperature: return true
        case .mass: return true
        case .bluetoothScales: return false
        }
    }
    var containsAccessory: Bool {
        switch self {
        case .muteSound: return false
        case .temperature: return false
        case .mass: return false
        case .bluetoothScales: return true
        }
    }
    
    var description: String {
        switch self {
        case .muteSound: return "Выключить звук"
        case .temperature: return "Температура"
        case .mass: return "Вес"
        case .bluetoothScales: return "Bluetooth весы"
        }
    }
}
    
    enum FeedbackOptions: Int, CaseIterable, SectionType {
        case email
        case vk
        case instagram
        case rateInAppStore
        
        var containsSwitch: Bool { return false }
        var containsAccessory: Bool { return !containsSwitch }
        var description: String {
            switch self {
            case .email: return "Email"
            case .vk: return "VK"
            case .instagram: return "Instagram"
            case .rateInAppStore: return "Rate in App Store"
        }
    }
}
    
    enum PrivacyOptions: Int, CaseIterable, SectionType {
        case privacyPolicy
        
        var containsSwitch: Bool { return false }
        var containsAccessory: Bool { return !containsSwitch }
        var description: String {
            switch self {
            case .privacyPolicy: return "Privacy Policy"
        }
    }
}
