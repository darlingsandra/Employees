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
    
    init(view: EmployeeListViewInput, interactor: EmployeeListInteractorInput) {
        self.view = view
       self.interactor = interactor
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
                position: employee.position
            )
        }
        view?.setEmployeeData(viewModels)
    }
}
