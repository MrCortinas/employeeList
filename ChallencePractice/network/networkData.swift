//
//  networkData.swift
//  ChallencePractice
//
//  Created by GCortinas on 3/19/24.
//

import Foundation
///collection of serive URL's
enum API: String {
    case allEmployees = "https://dummy.restapiexample.com/api/v1/employees"
    case employee = "https://dummy.restapiexample.com/api/v1/employee"
    case create = "https://dummy.restapiexample.com/api/v1/create"
    case update = "https://dummy.restapiexample.com/api/v1/update"
    case delete = "https://dummy.restapiexample.com/api/v1/delete"
    /// generate a URL to call the API
    func url(parameters: String?) -> URL? {
        if let value = parameters, !value.isEmpty {
            let urlString = self.rawValue + "/" + value
            return URL(string: urlString)
        }
        return URL(string: self.rawValue)
    }
    /// gets a general description of the service call
    func serviceName() -> String {
        switch self {
        case .allEmployees: return "All employees records"
        case .employee: return "Employee"
        case .create: return "Create employee"
        case .update: return "Update employee"
        case .delete: return "Delete employee"
        }
    }
    ///provides the method of the API call
    func Method() -> String {
        switch self {
        case .allEmployees: return "GET"
        case .employee: return "GET"
        case .create: return "POST"
        case .update: return "PUT"
        case .delete: return "DELETE"
        }
    }
    
    
    
    
}
///use to mocks the service calls
protocol NetworkAPI {
    func getAllEmployees(completionHandler: @escaping(AllEmployees?)->())
    func getSingleEmploye(id: String, completionHandler: @escaping(EmployeeSingle?)->())
    func postNewEmploye(body: [String:String], completionHandler: @escaping(CreateEmployee?)->())
    func putEmployee(id: String, body: [String:String], completionHandler: @escaping(UpdateEmployee?)->())
    func deleteEmploye(id: String, completionHandler: @escaping(DeleteEmployee?)->())
}

class NetworkSevice: NetworkAPI {
    ///we use this to MOCK webcalls
    static var callAPI: NetworkAPI = NetworkSevice()
    ///we use this as a wraper for our API
    static func serviceCall(apiURL: API, parameters: String?, body: Data?, headerFields:[String:String]? ,completionHandler: @escaping(Data?, HTTPURLResponse?, Error?)->()) {
        print("\n===================================Request: \(apiURL.serviceName())==================================\n")
        print("URL: \(apiURL.rawValue)/\(parameters ?? "")")
        if let headers = headerFields {
            print("Headers:")
            headers.forEach { print("✅ \($0): \($1)") }
        }
        if let data = body, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            print("Body: 📝\n\(String(decoding: jsonData, as: UTF8.self))")
        }
        print("\n===================================Request: \(apiURL.serviceName())==================================\n")
        if let url = apiURL.url(parameters: parameters) {
            var request = URLRequest(url: url)
            request.httpMethod = apiURL.Method()
            request.httpBody = body
            request.allHTTPHeaderFields = headerFields
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let error = error {
                    print("\n👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻\nNetwork call to URL:\(url)\nas produce the following Error:\n\(error)\n👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻👻")
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("\n\nError, unexpected status code:\n☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️\n\(String(describing: dump(response)))\n☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️☠️")
                    return
                }
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers), let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
                    print("\n===================================Response: \(apiURL.serviceName())==================================\n")
                    print("URL: \(url)")
                    print("Status Code: \(httpResponse.statusCode)")
                    print("Headers:")
                    httpResponse.allHeaderFields.forEach { print("✅ \($0): \($1)") }
                    print("Json response: 📝\n\(String(decoding: jsonData, as: UTF8.self))")
                    print("\n===================================Response: \(apiURL.serviceName())==================================\n")
                } else {
                    print("❌ json data malformed and/or it's not a json ❌")
                }
                completionHandler(data, httpResponse, error)
            })
            task.resume()
        } else {
            print("Error malformed or bad URL: \(apiURL.rawValue)")
        }
    }
    ///gets a list of all employees to display
    func getAllEmployees(completionHandler: @escaping(AllEmployees?)->()) {
        NetworkSevice.serviceCall(apiURL: .allEmployees, parameters: nil, body: nil, headerFields: nil) { (data, response, error) in
            if let data = data, let employeesdata = try? JSONDecoder().decode(AllEmployees.self, from: data) {
                completionHandler(employeesdata)
            }
        }
    }
    /// get  details data from employee by using the ID
    func getSingleEmploye(id: String, completionHandler: @escaping (EmployeeSingle?) -> ()) {
        NetworkSevice.serviceCall(apiURL: .employee, parameters: id, body: nil, headerFields: nil) {(data, response, error) in
            if let data = data, let employeesdata = try? JSONDecoder().decode(EmployeeSingle.self, from: data) {
                completionHandler(employeesdata)
            }
        }
    }
    /// can create a new employee with a dictionary EX:   body:  {"name":"test","salary":"123","age":"23"}
    func postNewEmploye(body: [String:String], completionHandler: @escaping (CreateEmployee?) -> ()) {
        var jsonData = Data()
        if let json = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) {
            jsonData = json
        }
        NetworkSevice.serviceCall(apiURL: .employee, parameters: nil, body: jsonData, headerFields: nil) {(data, response, error) in
            if let data = data, let employeesdata = try? JSONDecoder().decode(CreateEmployee.self, from: data) {
                completionHandler(employeesdata)
            }
        }
    }
    ///can update a user by using one employee ID and a dictionary EX:  id: "1"   body:   {"name":"test","salary":"123","age":"23"}
    func putEmployee(id: String, body: [String:String], completionHandler: @escaping (UpdateEmployee?) -> ()) {
        NetworkSevice.serviceCall(apiURL: .employee, parameters: id, body: nil, headerFields: nil) {(data, response, error) in
            if let data = data, let employeesdata = try? JSONDecoder().decode(UpdateEmployee.self, from: data) {
                completionHandler(employeesdata)
            }
        }
    }
    /// deletes a spesific user using the employee ID
    func deleteEmploye(id: String, completionHandler: @escaping (DeleteEmployee?) -> ()) {
        NetworkSevice.serviceCall(apiURL: .employee, parameters: id, body: nil, headerFields: nil) {(data, response, error) in
            if let data = data, let employeesdata = try? JSONDecoder().decode(DeleteEmployee.self, from: data) {
                completionHandler(employeesdata)
            }
        }
    }
}
