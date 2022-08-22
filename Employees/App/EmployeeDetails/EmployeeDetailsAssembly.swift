//
//  EmployeeDetailsAssembly.swift
//  Employees
//
//  Created by Александра Широкова on 16.08.2022.
//

import UIKit

/// Слой сборки модуля EmployeeDetails
final class EmployeeDetailsAssembly {}

extension EmployeeDetailsAssembly: Assemblying {
    func assembly(viewController: UIViewController, delegate: AnyObject? = nil, sender: Any?) {
        guard let vc = viewController as? EmployeeDetailsViewController else { return }
        let presenter = EmployeeDetailsPresenter(view: vc, sender: sender)
  
        vc.presenter = presenter
    }
}
