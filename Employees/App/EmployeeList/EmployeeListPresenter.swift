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
    private var employees: [Employee]?
    
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
    
    func showDetailsInfo(at id: String) {
        let employeeFist = employees?.first { $0.id == id }
        guard let sourseView = view, let employee = employeeFist else { return }
        router.route(view: sourseView, to: .detailView, with: employee)
    }
    
    func showSettings() {
        guard let sourseView = view else { return }
        router.route(view: sourseView, to: .sortView, with: nil)
    }
    
    func filterContent(_ search: String, category: Department) {
        guard let employees = employees else { return }

        let viewModels = employees
            .filter { isFilterEmployee(employee: $0, search: search, category: category) }
            .sorted { isSortEmployee(item1: $0, item2: $1, sort: SettingsManager.shared.sort) }
            .map { createEmployeeViewModel($0) }
       
        view?.setFilterEmployee(viewModels)
    }
}

extension EmployeeListPresenter: EmployeeListInteractorOutput {
    func receiveEmployeeData(_ employees: [Employee]) {
        self.employees = employees
        view?.employeeDataLoaded()
    }
    
    func receiveEmployeeDataError() {
        guard let sourseView = view else { return }
        router.route(view: sourseView, to: .errorView, with: nil)
    }
}

extension EmployeeListPresenter: EmployeeListRouterOutput {
    func updateEmployeeData() {
        interactor.provideEmployeeData()
    }
}

private extension EmployeeListPresenter {
    func createEmployeeViewModel(_ employee: Employee) -> EmployeeViewModel {
        EmployeeViewModel(
            id: employee.id,
            fullName: getFullNameEmployee(employee),
            tag: employee.userTag.lowercased(),
            position: employee.position,
            avatarUrl: employee.avatarUrl,
            birthYear: getBirthYearEmployee(employee) ?? "",
            birthDay: getBirthDayEmployee(employee) ?? ""
        )
    }
    
    func getFullNameEmployee(_ employee: Employee) -> String {
        "\(employee.firstName) \(employee.lastName)"
    }
    
    func getBirthDayEmployee(_ employee: Employee) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        if let date = dateFormatter.date(from: employee.birthday) {
            dateFormatter.dateFormat = "dd' 'MMM"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func getBirthYearEmployee(_ employee: Employee) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        if let date = dateFormatter.date(from: employee.birthday) {
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func isFilterEmployee(employee: Employee, search: String, category: Department) -> Bool {
        let isCategory = category == .all || employee.department == category.name
        
        if search.isEmpty && isCategory {
            return true
        } else {
            let fullName = getFullNameEmployee(employee)
            let isSearch = fullName.lowercased().contains(search.lowercased())
                || employee.userTag.lowercased().contains(search.lowercased())
            
            if isCategory && isSearch { return true}
        }
        return false
    }
    
    func isSortEmployee(item1: Employee, item2: Employee, sort: SettingsSort) -> Bool {
        switch sort {
        case .sortAlphabet:
            return getFullNameEmployee(item1) < getFullNameEmployee(item2)
        case .sortBirthday:
            return item1.birthday < item2.birthday
        }
    }
}
