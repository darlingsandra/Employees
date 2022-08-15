//
//  Assemblying.swift
//  Employees
//
//  Created by Александра Широкова on 02.08.2022.
//

import UIKit

/// Протокол компоновки VIPER-модулей на базе UIVIewController
protocol Assemblying {
    /// Собрать VIPER-модуль
    /// - Parameter viewController: UIViewController компонуемого модуля
    func assembly(viewController: UIViewController, delegate: AnyObject?)
}
