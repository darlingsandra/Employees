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
        let employees = Employee.getEmployees()
        presenter?.receiveEmployeeData(employees)
    }
}
