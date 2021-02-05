//
//  UserSettings.swift
//  CoffeeCult
//
//  Created by Admin on 03.02.2021.
//

import Foundation

enum SettingsKeys: String {
    case isUserNotFirstLogin
    case turnOffSound
    case temperatureInKelvin
    case weightInPounds
}

final class UserSettings {
    
    var isUserNotFirstLogin = UserDefaults.standard.bool(forKey: SettingsKeys.isUserNotFirstLogin.rawValue)
    var turnOffSound = UserDefaults.standard.bool(forKey: SettingsKeys.turnOffSound.rawValue)
    var temperatureInKelvin = UserDefaults.standard.bool(forKey: SettingsKeys.temperatureInKelvin.rawValue)
    var weightInPounds = UserDefaults.standard.bool(forKey: SettingsKeys.weightInPounds.rawValue)
}
