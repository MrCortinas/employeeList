//
//  ModelData.swift
//  Challange
//
//  Created by GCortinas on 3/15/24.
//

import Foundation
import SwiftData
@Model
final class modeldata {
    var countryNames: [country] = []
    init(countryList:  [country]) {
        self.countryNames = countryList
    }
}
