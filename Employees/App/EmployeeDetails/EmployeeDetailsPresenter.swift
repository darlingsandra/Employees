//
//  EmployeeDetailsPresenter.swift
//  Employees
//
//  Created by Александра Широкова on 16.08.2022.
//

import Foundation

/// Слой Presentation для модуля EmployeeDetails
final class EmployeeDetailsPresenter {
    private weak var view: EmployeeDetailsViewInput?
    private var employee: Employee?
    
    init(view: EmployeeDetailsViewInput, sender: Any?) {
        self.view = view
        self.employee = sender as? Employee
    }
}

extension EmployeeDetailsPresenter: EmployeeDetailsViewOutput {
    func readyShowData() {
        guard let employee = employee else { return }
        view?.setEmployeeData(viewModel: createEmployeeDetailsViewModel(employee))
    }
}

private extension EmployeeDetailsPresenter {
    
    func createEmployeeDetailsViewModel(_ employee: Employee) -> EmployeeDetailsViewModel {
        EmployeeDetailsViewModel(
            fullName: "\(employee.firstName) \(employee.lastName)",
            tag: employee.userTag.lowercased(),
            position: employee.position,
            avatarUrl: employee.avatarUrl,
            age: getAge(from: employee.birthday) ?? "",
            birthday: getFormatDate(from: employee.birthday) ?? "",
            phone: getFormatPhone(phoneNumber: employee.phone, cleanNumber: false) ?? "",
            call: getFormatPhone(phoneNumber: employee.phone, cleanNumber: true) ?? ""
        )
    }
    
    func getFormatDate(from string: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        if let date = dateFormatter.date(from: string) {
            dateFormatter.dateFormat = "d MMMM' 'yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    func getFormatPhone(phoneNumber: String, cleanNumber: Bool) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: "[\\s-]")
            let range = NSString(string: phoneNumber).range(of: phoneNumber)
            var number = regex.stringByReplacingMatches(in: phoneNumber, range: range, withTemplate: "")
            
            guard number.count == 10 else { return nil }
            guard !cleanNumber else { return "+7" + number }
            
            let pattern = "(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = number.replacingOccurrences(
                of: pattern,
                with: "($1) $2 $3 $4",
                options: .regularExpression,
                range: number.startIndex..<maxIndex
            )
            return "+7 " + number
        } catch {
            return nil
        }
    }
    
    func getAge(from string: String) -> String? {
        let currentDateComponents = Calendar.current.dateComponents([.year], from: Date())
        guard let currentYear = currentDateComponents.year else { return nil }
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy'-'MM'-'dd'"
        if let date = dateFormatter.date(from: string) {
            let dateComponents = Calendar.current.dateComponents([.year], from: date)
            guard let year = dateComponents.year else { return nil }
            return "\(currentYear - year) years"
        }
        return nil
    }
    
}
