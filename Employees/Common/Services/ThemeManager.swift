//
//  ThemeManager.swift
//  Employees
//
//  Created by Александра Широкова on 23.09.2022.
//

import UIKit

struct ThemeManager {
    static func applyTheme() {
        let appearanceBar = UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        let cancelButtonFont = UIFont(name: "Inter-SemiBold", size: 14) ?? .systemFont(ofSize: 14)
        let cancelButtonAttributes = [NSAttributedString.Key.font : cancelButtonFont]
        appearanceBar.setTitleTextAttributes(cancelButtonAttributes, for: .normal)
    }
}
