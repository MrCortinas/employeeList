//
//  Item.swift
//  ChallencePractice
//
//  Created by GCortinas on 3/18/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var id: String
    var name: String
    var salary: String
    var age: String
    var image: String
    
    init(id: String, name: String, salary: String, age: String, image: String) {
        self.id = id
        self.name = name
        self.salary = salary
        self.age = age
        self.image = image
    }
}
