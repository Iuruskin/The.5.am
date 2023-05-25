//
//  OrderCell.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 06.04.2023.
//

import SwiftUI

struct OrderCell: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var order : OrderModel
    
    var color : Color {
        switch order.status {
        case .delivered:
            return .green
        case .canceled:
            return .red
        default:
            return colorScheme == .dark ? .white : .black
        }
    }
    
    var str = "person.text.rectangle"
    
    var systemNameImageName : String {
        switch order.status {
        case .new:
            return "list.clipboard"
        case .inDelivery:
            return "airplane.departure"
        case .delivered:
            return "airplane.arrival"
        case .canceled:
            return "xmark.seal"
        case .paided:
            return "banknote"
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("\(order.date.formatted(.dateTime.day().month().year()))")
                        .modifier(RoundedTextSmall())
                    Text(order.status.rawValue)
                        .modifier(RoundedTextSmall())
                        .foregroundColor(self.color)
                }.padding(.leading, 3)
                Image(systemName: systemNameImageName)
                    .foregroundColor(color)
                    .padding(.leading, 3)
                Text("\(order.cost + order.deliveryCost) ₽")
                    .modifier(RoundedTextSmall())
                    .padding(.trailing, 3)
                VStack {
                    Text("ID заказа:")
                        .modifier(RoundedTextSmall())
                    Text(getFirthEightOrderId(id:order.id))
                        .modifier(RoundedTextSmall())
                }.padding(.trailing, 3)
            }
            if order.trackNumber != "" {
                Text("Трек номер: \(order.trackNumber)")
                    .modifier(RoundedTextSmall())
                    .padding(.top, 8)
            }
        }
        .frame(maxWidth: screen.width)
        .padding(.vertical, 15)
        .background(colorScheme == .dark ? .black : .white)
        .cornerRadius(10)
        .shadow(color: Color(uiColor: .systemGray4), radius: 3)
        .padding(.horizontal, 6)
    }
}





struct OrderCell_Previews: PreviewProvider {
    static var previews: some View {
        OrderCell(order: OrderModel(iserID: "74657", date: Date(), status: OrderStatusEnum.canceled, custom: false, trackNumber: "TR635736RU", deliveryCost: 1356, deliveryWay: "Почта Рф"))
    }
}
