//
//  EmployeeListPresenter.swift
//  Employees
//
//  Created by Александра Широкова on 02.08.2022.
//

import Foundation

/// Слой Presentation для модуля EmployeeList
final class EmployeeListPresenter {
    
    private weak var view: EmployeeListViewInput?
    private let interactor: EmployeeListInteractorInput!
    private let router: EmployeeListRoutable!
    
    init(view: EmployeeListViewInput, interactor: EmployeeListInteractorInput, router: EmployeeListRoutable) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension EmployeeListPresenter: EmployeeListViewOutput {
    func readyForLoadData() {
        interactor.provideEmployeeData()
    }
}
extension EmployeeListPresenter: EmployeeListInteractorOutput {
    
    func receiveEmployeeData(_ employees: [Employee]) {
        let viewModels = employees.map { employee in
            EmployeeViewModel(
                fullName: "\(employee.firstName) \(employee.lastName)",
                tag: employee.userTag.lowercased(),
                position: employee.position,
                avatarUrl: employee.avatarUrl
            )
        }
        view?.setEmployeeData(viewModels)
    }
    
    func receiveEmployeeDataError() {
        guard let sourseView = view else { return }
        router.route(view: sourseView, to: .errorView)
    }
}

extension EmployeeListPresenter: EmployeeListRouterOutput {
    func updateEmployeeData() {
        interactor.provideEmployeeData()
    }
}
