//
//  tebleviewContoller.swift
//  Challange
//
//  Created by GCortinas on 3/15/24.
//

import Foundation
import SwiftUI
import SwiftData


struct CountryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [vModeldata]
    private var data: modeldata
    
    init(data: modeldata) {
        self.data = data
        self.data.countryNames.forEach { country in
            let newItem = vModeldata(countryName: country.country)
            modelContext.insert(newItem)
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.countryName)")
                    } label: {
                        Text(item.countryName)
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
