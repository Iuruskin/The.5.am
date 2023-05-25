//
//  PositionCell.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 31.03.2023.
//

import SwiftUI

struct PositionCell: View {
    
    let position : PositionModel
    
    var body: some View {
            HStack(spacing: 20) {
                Text(position.product.title)
                    .modifier(RoundedTextMedium())
                Text("\(position.count)шт")
                    .modifier(RoundedTextMedium())
                Text("\(position.color.rawValue)")
                    .modifier(RoundedTextMedium())
                Text("\(position.cost) ₽")
                    .modifier(RoundedTextMedium())
        }
            .padding(.vertical)
        
    }
}

struct PositionCell_Previews: PreviewProvider {
    static var previews: some View {
        PositionCell(position: PositionModel(id: UUID().uuidString, product: ProductModel(id: UUID().uuidString, type: .hanger, title: "Петух 35", description: "", color: [.silver,.black], material: "", price: 600, weight: 200, countAvialable: [.black: 6]), color: .silver, count: 4))
    }
}
