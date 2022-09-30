//
//  SettingsManager.swift
//  Employees
//
//  Created by Александра Широкова on 27.09.2022.
//

import Foundation

enum Settings: String {
    case sortEmployee
}

enum SettingsSort: String {
    case sortAlphabet
    case sortBirthday
}

final class SettingsManager {
   
    static let shared = SettingsManager()
    
    private let defaults = UserDefaults.standard
    private init() {}
    
    var sort: SettingsSort {
        get {
            if let sortString = defaults.value(forKey: Settings.sortEmployee.rawValue) as? String {
                return SettingsSort.init(rawValue: sortString) ?? SettingsSort.sortAlphabet
            }
            return SettingsSort.sortAlphabet
        }
        set {
            defaults.set(newValue.rawValue, forKey: Settings.sortEmployee.rawValue)
        }
    }
}
