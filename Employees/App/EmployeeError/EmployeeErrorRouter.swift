//
//  EmployeeErrorRouter.swift
//  Employees
//
//  Created by Александра Широкова on 10.08.2022.
//

import Foundation

protocol EmployeeErrorRoutable {
    func route(to target: Target)
}

final class EmployeeErrorRouter {
    var delegate: EmployeeListRouterDelegate?
}

extension EmployeeErrorRouter: EmployeeErrorRoutable {
    func route(to target: Target) {
        if target == .tableView {
            delegate?.routeBack()
        }
    }
}
