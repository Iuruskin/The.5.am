//
//  ProductModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import Foundation
import FirebaseFirestore

struct ProductModel {
    
    var id: String
    var type: TypeEnum
    var title: String
    var description: String
    var color : [avialableColor]
    var material: String
    var price: Int
    var weight: Int?
    var countAvialable: [avialableColor:Int]
    
    
    var dollarPrice: Int {
        price / 65
        // получить это значение через api, или хотя бы из firebase
    }
    var colorStr : [String] {
        var str = [String]()
        for col in color {
            str.append(col.rawValue)
        }
        return str
    }
    
    var countAvialableStr : [String: Int] {
        var ret = [String: Int]()
        for (color, value) in countAvialable {
            ret[color.rawValue] = value
        }
        return ret
    }
    
    var representation : [String: Any] {
        var represent = [String: Any]()
        represent[ProductEnum.id.rawValue] = id
        represent[ProductEnum.type.rawValue] = type.rawValue
        represent[ProductEnum.title.rawValue] = title
        represent[ProductEnum.description.rawValue] = description
        represent[ProductEnum.color.rawValue] = colorStr
        represent[ProductEnum.material.rawValue] = material
        represent[ProductEnum.price.rawValue] = price
        represent[ProductEnum.weight.rawValue] = weight
        represent[ProductEnum.countAvialable.rawValue] = countAvialableStr
        return represent
    }
    
    internal init(id: String, type: TypeEnum, title: String, description: String, color : [avialableColor], material: String, price: Int, weight: Int?, countAvialable: [avialableColor:Int]) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.color = color
        self.material = material
        self.price = price
        self.weight = weight
        self.countAvialable = countAvialable
    }

    init?(doc: QueryDocumentSnapshot) {
        let data = doc.data()
        guard let id = data[ProductEnum.id.rawValue] as? String else { return nil }
        guard let type = data[ProductEnum.type.rawValue] as? String else { return nil }
        guard let title = data[ProductEnum.title.rawValue] as? String else { return nil }
        guard let description = data[ProductEnum.description.rawValue] as? String else { return nil }
        guard let color = data[ProductEnum.color.rawValue] as? [String] else { return nil }
        guard let material = data[ProductEnum.material.rawValue] as? String else { return nil }
        guard let price = data[ProductEnum.price.rawValue] as? Int else { return nil }
        guard let weight = data[ProductEnum.weight.rawValue] as? Int? else { return nil }
        guard let countAvialable = data[ProductEnum.countAvialable.rawValue] as? [String: Int] else { return nil }
        
        var enumColor : [avialableColor] {
            var result = [avialableColor]()
            for col in color {
                result.append(avialableColor(rawValue: col)!)
            }
            return result
        }
        
        var enumAvialableColor : [avialableColor: Int] {
            var result = [avialableColor: Int]()
            for (color, value) in countAvialable {
                result[avialableColor(rawValue: color)!] = value
            }
            return result
        }
        
        self.id = id
        self.type = TypeEnum(rawValue: type)!
        self.title = title
        self.description = description
        self.color = enumColor
        self.material = material
        self.price = price
        self.weight = weight
        self.countAvialable = enumAvialableColor
        
    }
    
    
    
}




