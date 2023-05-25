//
//  TabButtomView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import SwiftUI

struct TabButtomView: View {
    
    let tabBarItems : [TabItemModel]
    @Binding var selectedIndex : Int
    
    var body: some View {
        ZStack {
            gradient
            HStack {
                ForEach(tabBarItems.indices) { index in
                    Spacer()
                    VStack {
                        let item = tabBarItems[index]
                        Button {
                            self.selectedIndex = index
                        } label: {
                            let selected = selectedIndex == index
                            TabCellView(data: item, isSelected: selected)
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(width: screen.width - 30, height: 80)
        .background(.white)
        .cornerRadius(20)
        .shadow(color: .gray, radius: 10)
    }
}


struct CustomTabView<Content: View>: View {
    let tabs: [TabItemModel]
    @Binding var selectedIndex: Int
    @ViewBuilder let content : (Int) -> Content
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedIndex) {
                ForEach(tabs.indices) { index in
                    content(index)
                        .tag(index)
                }
                .toolbarBackground(.hidden, for: .tabBar)
            }
            
            VStack {
                Spacer()
               TabButtomView(tabBarItems: tabs, selectedIndex: $selectedIndex)
                    .padding(.bottom, 17)
            }.ignoresSafeArea()
        }
    }
}

enum TabType : Int, CaseIterable {
    case catalog = 0
    case cart
    case customOrder
    case profile
    
    var tabItem: TabItemModel {
        switch self {
        case .catalog:
            return TabItemModel(image: "goods", title: "Каталог")
        case .cart:
            return TabItemModel(image: "cart", title: "Корзина")
        case .customOrder:
            return TabItemModel(image: "customOrder", title: "Кастом")
        case .profile:
            return TabItemModel(image: "profile", title: "Профиль")
        }
    }
}



struct TabButtomView_Previews: PreviewProvider {
    static var previews: some View {
        TabButtomView(tabBarItems: [TabItemModel(image: "cart", title: "корзина"),
                                    TabItemModel(image: "cart", title: "заказать"),
                                    TabItemModel(image: "cart", title: "профиль")
                                   ], selectedIndex: .constant(1))
    }
}

