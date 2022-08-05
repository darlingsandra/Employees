//
//  EmployeeListAssembly.swift
//  Employees
//
//  Created by Александра Широкова on 02.08.2022.
//

import UIKit

/// Слой сборки модуля EmployeeList
final class EmployeeListAssembly {}

extension EmployeeListAssembly: Assemblying {
    func assembly(viewController: UIViewController) {
        guard let vc = viewController as? EmployeeListViewController else { return }
        let interactor = EmployeeListInteractor()
        let presenter = EmployeeListPresenter(view: vc, interactor: interactor)
        
        vc.presenter = presenter
        interactor.presenter = presenter
    }
}
