//
//  Employee.swift
//  Employees
//
//  Created by Александра Широкова on 02.08.2022.
//

import Foundation

enum Department: String, CaseIterable {
    case all = "Все"
    case android = "Android"
    case ios = "iOS"
    case design = "Дизайн"
    case management = "Менеджмент"
    case qa = "QA"
    case back_office = "Бэк-офис"
    case frontend = "Frontend"
    case hr = "HR"
    case pr = "PR"
    case backend = "Backend"
    case support = "Техподдержка"
    case analytics = "Аналитика"
    
    var name: String {
        switch self {
        case .all: return "all"
        case .android: return "android"
        case .ios: return "ios"
        case .design: return "design"
        case .management: return "management"
        case .qa: return "qa"
        case .back_office: return "back_office"
        case .frontend: return "frontend"
        case .hr: return "hr"
        case .pr: return "pr"
        case .backend: return "backend"
        case .support: return "support"
        case .analytics: return "analytics"
        }
    }
}

struct EmployeeList: Decodable {
    let items: [Employee]
}

struct Employee: Decodable {
    let id: String
    let avatarUrl: String
    let firstName: String
    let lastName: String
    let userTag: String
    let department: String
    let position: String
    let birthday: String
    let phone: String
    
    static func getEmployees() -> [Employee] {
        [
            Employee(
                id: "e0fceffa-cef3-45f7-97c6-6be2e3705927",
                avatarUrl: "https://cdn.fakercloud.com/avatars/marrimo_128.jpg",
                firstName: "Dee",
                lastName: "Reichert",
                userTag: "LK",
                department: "back_office",
                position: "Technician",
                birthday: "2004-08-02",
                phone: "802-623-1785"
            ),
            Employee(
                id: "6712da93-2b1c-4ed3-a169-c69cf74c3291",
                avatarUrl: "https://cdn.fakercloud.com/avatars/alterchuca_128.jpg",
                firstName: "Kenton",
                lastName: "Fritsch",
                userTag: "AG",
                department: "analytics",
                position: "Orchestrator",
                birthday: "1976-06-14",
                phone: "651-313-1140"
            ),
            Employee(
                id: "514bec78-d65d-4140-81d7-e23fb3fc3ba8",
                avatarUrl: "https://cdn.fakercloud.com/avatars/vitorleal_128.jpg",
                firstName: "Hanna",
                lastName: "Kling",
                userTag: "PY",
                department: "android",
                position: "Strategist",
                birthday: "1994-12-17",
                phone: "980-962-6297"
            )
        ]
    }
}
