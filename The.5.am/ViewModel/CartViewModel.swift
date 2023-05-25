//
//  DataController.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 11.05.2023.
//

import Foundation
import CoreData

class CartViewModel: ObservableObject {
    let container = NSPersistentContainer(name: "CoreDataModelCart")
    
    static let shared = CartViewModel()
    
    @Published var savedEntities: [Positions] = []
    
    var cost : Int {
        var result = 0
        for summa in savedEntities {
            result += Int(summa.cost)
        }
        return result
    }
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load \(error.localizedDescription)")
            } else {
                print("Seccessfully loaded core data")
            }
        }
    }
    
    func fetchPositions() {
        let request = NSFetchRequest<Positions>(entityName: "Positions")
        // изменить позиции
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching \(error.localizedDescription)")
        }
    }
    
    func addPosition(positions: PositionModel) {
        let position = Positions(context: container.viewContext)
        position.title = positions.product.title
        position.id = positions.id
        position.color = positions.color.rawValue
        position.count = Int64(positions.count)
        position.cost = Int64(positions.cost)
        position.price = Int64(positions.product.price)
        saveData()
    }
    
    func deletePosition(at offsets: IndexSet) {
        guard let index = offsets.first else { return }
        let entity = savedEntities[index]
        container.viewContext.delete(entity)
        saveData()
        
    }
    
    func deleteAllPosition() {
        for position in savedEntities {
            container.viewContext.delete(position)
        }
        saveData()
    }
    
    func saveData() {
        do {
            try container.viewContext.save()
            fetchPositions()
        } catch let error {
            print("Error saving \(error.localizedDescription)")
        }
    }
}
