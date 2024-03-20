//
//  EmployeeJsonData.swift
//  ChallencePractice
//
//  Created by GCortinas on 3/19/24.
//

import Foundation

struct Employee: Codable {
    let id: Int?
    let employee_salary: Int?
    let employee_name: String?
    let employee_age: Int?
    let profile_image: String?
}

struct AllEmployees: Codable {
    let status: String?
    let data: [Employee]?
    let message: String?
}

struct EmployeeSingle: Codable {
    let status: String?
    let data: Employee?
}

struct CreateEmployee: Codable {
    let status: String?
    let data: NewEmployee?
}

struct NewEmployee: Codable {
    let name: String
    let salary: String?
    let age: String?
    let id: Int?
}

struct UpdateEmployee: Codable {
    let status: String?
    let data: NewEmployee?
}

struct DeleteEmployee: Codable {
    let status: String?
    let message: String?
}
