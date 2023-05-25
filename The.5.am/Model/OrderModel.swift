//
//  OrderModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 04.04.2023.
//

import Foundation
import FirebaseFirestore
import SwiftUI

struct OrderModel : Identifiable {
    var id : String = UUID().uuidString
    var userID : String
    var position = [PositionModel]()
    var date : Date
    var status : OrderStatusEnum
    var custom : Bool
    
    
    var statusStr : String {
        return status.rawValue
    }
    
    var trackNumber : String = ""
    var deliveryCost : Int
    var deliveryWay : String
    
    
   var cost : Int {
        var sum = 0
        for pos in position {
            sum += pos.cost
        }
        return sum
    }
    
    var representation : [String: Any] {
        var represent = [String: Any]()
        represent[OrderEnum.id.rawValue] = id
        represent[OrderEnum.userID.rawValue] = userID
        represent[OrderEnum.date.rawValue] = date
        represent[OrderEnum.status.rawValue] = statusStr
        represent[OrderEnum.custom.rawValue] = custom
        represent[OrderEnum.trackNumber.rawValue] = trackNumber
        represent[OrderEnum.cost.rawValue] = cost
        represent[OrderEnum.deliveryCost.rawValue] = deliveryCost
        represent[OrderEnum.deliveryWay.rawValue] = deliveryWay
        return represent
    }
    
    
   
    
    init(id: String = UUID().uuidString, iserID: String, position: [PositionModel] = [PositionModel](), date: Date, status: OrderStatusEnum, custom: Bool, trackNumber: String, deliveryCost: Int, deliveryWay: String) {
        self.id = id
        self.userID = iserID
        self.position = position
        self.date = date
        self.status = status
        self.custom = custom
        self.trackNumber = trackNumber
        self.deliveryCost = deliveryCost
        self.deliveryWay = deliveryWay
    }
    
    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        
        guard let id = data[OrderEnum.id.rawValue] as? String else { return nil }
        guard let userID = data[OrderEnum.userID.rawValue] as? String else { return nil }
        guard let date = data[OrderEnum.date.rawValue] as? Timestamp else { return nil }
        guard let status = data[OrderEnum.status.rawValue] as? String else { return nil }
        guard let custom = data[OrderEnum.custom.rawValue] as? Bool else { return nil }
        guard let track = data[OrderEnum.trackNumber.rawValue] as? String else { return nil }
        guard let deliveryCost = data[OrderEnum.deliveryCost.rawValue] as? Int else { return nil }
        guard let deliveryWay = data[OrderEnum.deliveryWay.rawValue] as? String else { return nil }
        
        
        self.id = id
        self.userID = userID
        self.date = date.dateValue()
        self.status = OrderStatusEnum(rawValue: status)!
        self.custom = custom
        self.trackNumber = track
        self.deliveryCost = deliveryCost
        self.deliveryWay = deliveryWay
    }
}


