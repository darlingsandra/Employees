//
//  EmployeeListRouter.swift
//  Employees
//
//  Created by Александра Широкова on 10.08.2022.
//

import UIKit

enum Target {
    case tableView
    case detailView
    case errorView
}

protocol EmployeeListRoutable {
    func route(view: EmployeeListViewInput, to target: Target, with data: Employee?)
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
    func route(view: EmployeeListViewInput, to target: Target, with data: Employee? = nil) {
        guard let sourceView = view as? UIViewController else { return }
        if target == .errorView {
            let nextView = EmployeeErrorViewController()
            EmployeeErrorAssembly().assembly(viewController: nextView, delegate: self, sender: nil)
            sourceView.present(nextView, animated: true)
        }
        if target == .detailView {
            let nextView = EmployeeDetailsViewController()
            EmployeeDetailsAssembly().assembly(viewController: nextView, sender: data)
            sourceView.navigationController?.pushViewController(nextView, animated: true)
        }
    }
}

extension EmployeeListRouter: EmployeeListRouterDelegate {
    func routeBack() {
        presenter?.updateEmployeeData()
    }
}
