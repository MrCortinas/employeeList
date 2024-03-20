//
//  webAPIcall.swift
//  Challange
//
//  Created by GCortinas on 3/15/24.
//

import Foundation

struct country: Codable {
    let country: String
}
class networkcall {
    static func fetchCountries(completionHandler: @escaping ([country]) -> ()) {
        if let url = URL(string: "https://demo5860090.mockable.io/countries") {
            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if let error = error {
                    print("https://demo5860090.mockable.io/countries\nError with fetching countries: \(error)")
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    print("\n\nError with the response, unexpected status code:\n\n\(String(describing: response))\n\n")
                    return
                }
                if let data = data, let countriesSummary = try? JSONDecoder().decode([country].self, from: data) {
                    completionHandler(countriesSummary)
                }
            })
            task.resume()
        }
    }
}
