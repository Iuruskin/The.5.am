//  PositionModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 31.03.2023.
//

import Foundation
import FirebaseFirestore

struct PositionModel : Identifiable {
    var id : String
    var product : ProductModel
    var color : avialableColor
    var colorStr : String {
        color.rawValue
    }
    var count : Int
    
    var cost : Int {
        product.price * self.count
    }
    
    internal init(id: String, product: ProductModel, color: avialableColor, count: Int) {
        self.id = id
        self.product = product
        self.color = color
        self.count = count
    }
    
    var representation : [String: Any] {
        var represent = [String: Any]()
        represent[PositionEnum.id.rawValue] = id
        represent[PositionEnum.title.rawValue] = product.title
        represent[PositionEnum.color.rawValue] = colorStr
        represent[PositionEnum.price.rawValue] = product.price
        represent[PositionEnum.count.rawValue] = count
        represent[PositionEnum.cost.rawValue] = cost
        represent[PositionEnum.material.rawValue] = product.material
        represent[PositionEnum.description.rawValue] = product.description
        
        return represent
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let id = data[PositionEnum.id.rawValue] as? String else { return nil }
        guard let color = data[PositionEnum.color.rawValue] as? String else { return nil }
        guard let count = data[PositionEnum.count.rawValue] as? Int else { return nil }
        guard let title = data[PositionEnum.title.rawValue] as? String else { return nil }
        guard let price = data[PositionEnum.price.rawValue] as? Int else { return nil }
        guard let description = data[PositionEnum.description.rawValue] as? String else { return nil }
        guard let cost = data[PositionEnum.cost.rawValue] as? Int else { return nil }
        guard let material = data[PositionEnum.material.rawValue] as? String else { return nil }
        
        let product : ProductModel = ProductModel(id: "", type: TypeEnum.hanger, title: title, description: description, color: [avialableColor(rawValue: color)!], material: material, price: price, weight: 0, countAvialable: [.black: 0])
        
        self.id = id
        self.product = product
        self.count = count
        self.color = avialableColor(rawValue: color)!
    }
    
    init?(entities: Positions) {
        guard let id = entities.id else { return nil }
        guard let title = entities.title else { return nil }
        guard let color = entities.color else { return nil }
        
        let product : ProductModel = ProductModel(id: "", type: TypeEnum.hanger, title: title, description: "", color: [avialableColor(rawValue: color)!], material: "", price: Int(entities.price), weight: 0, countAvialable: [.black: 0])
        
        self.id = id
        self.color = avialableColor(rawValue: color)!
        self.count = Int(entities.count)
        self.product = product
            
    }
}



