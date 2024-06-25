//
//  SwiftUIView.swift
//  ChallencePractice
//
//  Created by GCortinas on 3/26/24.
//

import SwiftUI

struct Animal: Identifiable {
    var id = UUID()
    var name: String
}

struct AnimalGroup: Identifiable {
    var id = UUID()
    var groupName : String
    var animals : [Animal]
}


struct SwiftUIView: View {
    
    @State var animalGroups = [
        AnimalGroup(groupName: "Pets", animals: [
            Animal(name: "Dog"),
            Animal(name: "Cat"),
            Animal(name: "Parrot"),
            Animal(name: "Mouse")
        ]),
        AnimalGroup(groupName: "Farm", animals: [
            Animal(name: "Cow"),
            Animal(name: "Horse"),
            Animal(name: "Goat"),
            Animal(name: "Sheep"),
        ]),
        AnimalGroup(groupName: "Critters", animals: [
            Animal(name: "Firefly"),
            Animal(name: "Spider"),
            Animal(name: "Ant"),
            Animal(name: "Squirrel"),
        ])
    ]
    
    @State var animals = [
        Animal(name: "Dog"),
        Animal(name: "Cat"),
        Animal(name: "Parrot")
    ]
    
    var body: some View {
        Text("I ❤️ List").font(.headline)
        List() {
            ForEach(animalGroups) { animalGroup in
                Section(header: Text(animalGroup.groupName).font(.largeTitle)) {
                    ForEach(animalGroup.animals) { animal in
                        Text(animal.name).font(.headline)
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        
        Button(action: signIn) {
            Text("load more")
        }
    }
    
    func signIn() {
        animals.append(Animal(name: "NEW Animal"))
    }
    
}

#Preview {
    SwiftUIView()
}
