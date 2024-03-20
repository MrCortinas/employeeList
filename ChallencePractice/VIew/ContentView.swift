//
//  ContentView.swift
//  ChallencePractice
//
//  Created by GCortinas on 3/18/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showTicTacToeView = false
    @State private var showContactsView = false
    
    var body: some View {
        NavigationSplitView {
            Button(action: contactsList) {
                Label("Load Contact", systemImage: "arrow.down")
            }.padding()
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("id: \(item.id)")
                        Text("name: \(item.name)")
                        Text("salary: \(item.salary)")
                        Text("age: \(item.age)")
                    } label: {
                        Text("id: \(item.id)\nname: \(item.name)\nsalary: \(item.salary)\nage: \(item.age)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Button(action: tictactoeGame) {
                Label("Navigate to TICTACTOE", systemImage: "arrow.up")
            }.padding()
            NavigationLink("", destination:  TictactToe(), isActive: $showTicTacToeView)
        } detail: {
            Text("Select an item")
        }
        
        
       
        
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(id: "0", name: "test", salary: "10000", age: "40", image: "")
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func tictactoeGame() {
        showTicTacToeView = !showTicTacToeView
    }
    
    private func contactsList() {
        
        NetworkSevice.getAllEmployees { employeelist in
            for index in (0 ..< items.count).reversed() {
                modelContext.delete(items[index])
            }
            employeelist?.data?.forEach({ Employee in
                let newItem = Item(id: "\(Employee.id ?? 0)", name: "\(Employee.employee_name ?? "")", salary: "\(Employee.employee_salary ?? 0)", age: "\(Employee.employee_age ?? 0)", image: "\(Employee.profile_image ?? "")")
                modelContext.insert(newItem)
            })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
