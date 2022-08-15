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
    func assembly(viewController: UIViewController, delegate: AnyObject? = nil) {
        guard let vc = viewController as? EmployeeListViewController else { return }
        let interactor = EmployeeListInteractor()
        let router = EmployeeListRouter()
        let presenter = EmployeeListPresenter(view: vc, interactor: interactor, router: router)
        
        router.presenter = presenter
        vc.presenter = presenter
        interactor.presenter = presenter
    }
}
