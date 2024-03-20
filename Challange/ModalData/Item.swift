//
//  Item.swift
//  Challange
//
//  Created by GCortinas on 3/15/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
