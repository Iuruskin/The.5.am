//
//  ColorsEnum.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import Foundation

enum avialableColor : String, CaseIterable {
    case red = "Красный"
    case blue = "Синий"
    case black = "Черный"
    case silver = "Серебристый"
    case gold = "Золотой"
    case green = "Зеленый"
    case purple = "Фиолетовый"
}

enum delivery : String, CaseIterable {
    case postOfRussia = "Почта россии"
    case sdek = "СДЕК"
    case selfTakeOut = "Самовывоз в Калининграде"
}


enum TypeEnum : String, CaseIterable {
    case hanger = "Петухи"
    case chainring = "Звезды"
    case other = "Прочее"
    case tool = "Инструменты"
    case light = "Освещение"
}




enum OrderStatusEnum : String, Equatable, CaseIterable {
    case new = "Новый"
    case paided = "Оплачен"
    case inDelivery = "В доставке"
    case delivered = "Доставлен"
    case canceled = "Отменен"
}

enum ProductEnum : String {
    case id
    case type
    case title
    case description
    case color
    case material
    case price
    case weight
    case countAvialable
}


enum PositionEnum : String {
    case id
    case title
    case product
    case price
    case color
    case count
    case description
    case material
    case cost
}


enum MWUserEnum : String {
    case id
    case name
    case lastName
    case adress
    case phone
    case isAdmin
    case email
}



enum infoEnum : String {
    case email
    case phone
    case telegram
    case howToPay
    case about
    case instagram
    case fio
    case iban
    case fioEng
    case privacy
}


enum OrderEnum : String {
    case id
    case userID
    case date
    case status
    case custom
    case trackNumber
    case deliveryCost
    case deliveryWay
    case cost
}


enum DeliveryWay : String {
    case id
    case name
    case price
}
