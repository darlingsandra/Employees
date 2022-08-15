//
//  EmployeeErrorPresenter.swift
//  Employees
//
//  Created by Александра Широкова on 10.08.2022.
//

import Foundation

final class EmployeeErrorPresenter {
    private weak var view: EmployeeErrorViewInput?
    private let router: EmployeeErrorRouter!
    
    init(view: EmployeeErrorViewInput, router: EmployeeErrorRouter) {
        self.view = view
        self.router = router
    }
}

extension EmployeeErrorPresenter: EmployeeErrorViewOutput {
    func readyForUpdateData() {
        router.route(to: .tableView)
    }
}
