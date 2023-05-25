//
//  TabItemView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import SwiftUI

struct TabCellView: View {
    
    let data : TabItemModel
    let isSelected : Bool
    
    var body: some View {
        VStack {
            Image(data.image)
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .foregroundColor(isSelected ? Color(uiColor: .systemRed) : Color(uiColor: .black))
                .animation(.default, value: 0.5)
            Text(data.title)
                .foregroundColor(isSelected ? Color(uiColor: .systemRed) : Color(uiColor: .black))
                .font(.system(.body, design: .rounded, weight: .regular))
        }
    }
}



struct TabCellView_Previews: PreviewProvider {
    static var previews: some View {
        TabCellView(data: TabItemModel(image: "cart", title: "Каталог"), isSelected: false)
    }
}

