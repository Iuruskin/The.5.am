//
//  DeliveryModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 12.05.2023.
//

import Foundation
import FirebaseFirestore

struct DeliveryModel : Identifiable {
    
    var id : String = UUID().uuidString
    var name : String
    var price : Int
    
    init(name: String, price: Int) {
        self.id = UUID().uuidString
        self.name = name
        self.price = price
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let id = data[DeliveryWay.id.rawValue] as? String else { return nil }
        guard let name = data[DeliveryWay.name.rawValue] as? String else { return nil }
        guard let price = data[DeliveryWay.price.rawValue] as? Int else { return nil }
        
        self.id = id
        self.name = name
        self.price = price
    }
    
    var representation : [String: Any] {
        var represent = [String: Any]()
        represent[DeliveryWay.id.rawValue] = id
        represent[DeliveryWay.name.rawValue] = name
        represent[DeliveryWay.price.rawValue] = price
        return represent
    }
}



