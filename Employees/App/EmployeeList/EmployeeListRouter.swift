//
//  EmployeeListRouter.swift
//  Employees
//
//  Created by Александра Широкова on 10.08.2022.
//

import UIKit

enum Target {
    case tableView
    case errorView
}

protocol EmployeeListRoutable {
    func route(view: EmployeeListViewInput, to target: Target)
}

/// Протокол передачи данных слою презентации модуля EmployeeList
protocol EmployeeListRouterOutput: AnyObject {
    func updateEmployeeData()
}

/// Протокол передачи данных от модуля EmployeeError
protocol EmployeeListRouterDelegate {
    func routeBack()
}

final class EmployeeListRouter {
    weak var presenter: EmployeeListRouterOutput?
}

extension EmployeeListRouter: EmployeeListRoutable {
    func route(view: EmployeeListViewInput, to target: Target) {
        if target == .errorView {
            guard let sourceView = view as? UIViewController else { return }
            let nextView = EmployeeErrorViewController()
            EmployeeErrorAssembly().assembly(viewController: nextView, delegate: self)
            sourceView.present(nextView, animated: true)
        }
    }
}

extension EmployeeListRouter: EmployeeListRouterDelegate {
    func routeBack() {
        presenter?.updateEmployeeData()
    }
}
