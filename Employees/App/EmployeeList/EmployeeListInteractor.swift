//
//  EmployeeListInteractor.swift
//  Employees
//
//  Created by Александра Широкова on 02.08.2022.
//

import Foundation

/// Протокол управления бизнес логикой модуля EmployeeList
protocol EmployeeListInteractorInput {
    /// Осуществить загрузку данных
    func provideEmployeeData()
}

/// Протокол передачи данных слою  презентации модуля EmployeeList
protocol EmployeeListInteractorOutput: AnyObject {
    /// Получить view модель данных
    func receiveEmployeeData(_ employees: [Employee])
}

/// Слой бизнес логики
final class EmployeeListInteractor {
    weak var presenter: EmployeeListInteractorOutput?
}

extension EmployeeListInteractor: EmployeeListInteractorInput {
    func provideEmployeeData() {
        NetworkManager.shared.fetch(
            dataType: EmployeeList.self,
            url: API.employeeURL.rawValue) { [weak self] result in
            switch result {
            case .success(let employeeList):
                self?.presenter?.receiveEmployeeData(employeeList.items)
            case .failure(let error):
                print(error)
            }
        }
    }
}
