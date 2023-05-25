//
//  ContentView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 29.03.2023.
//

import SwiftUI

struct MainTabView: View {
    
    var count = 1
    @State var selectedIndex = 0
    
    
    var body: some View {
        NavigationView {
            CustomTabView(tabs: TabType.allCases.map({ $0.tabItem}), selectedIndex: $selectedIndex) { index in
                let type = TabType(rawValue: index) ?? .catalog
                getTabView(type: type)
            }
        }
    }
    
    @ViewBuilder
    func getTabView(type: TabType) -> some View {
        switch type {
        case .catalog:
            CatalogView()
        case .cart:
            CartView(dataModel: CartViewModel.shared, deliveryModel: DeliveryViewModel())
        case .customOrder:
            CustomOrderView(color: .black, photos: Photos())
        case .profile:
            ProfileView(viewModel: ProfileViewModel(profile: MWUser(id: "", name: "", lastName: "", adress: "", phone: "", email: "")))
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            MainTabView()
    }
}
