//
//  AdminPanel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 11.04.2023.
//

import SwiftUI

struct AdminPanel: View {
    
    @StateObject var adminViewModel = AdminOrdersViewModel()
    @StateObject var profileViewModel : ProfileViewModel
    @State var isOrderViewShow = false
    @State var isShowAuthView = false
    @State var isShowAddProductView = false
    @State var isShowDeliveryWays = false
    
    var body: some View {
        ScrollView(.vertical) {
            HStack {
                    Button {
                        isShowAddProductView.toggle()
                    } label: {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 25)
                            .foregroundColor(Color("5amBlue"))
                    }
                    Button {
                        AuthService.shared.signOut()
                        profileViewModel.isProfileView.toggle()
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 25)
                            .foregroundColor(Color("5amBlue"))
                    }
                    Button {
                        isShowDeliveryWays.toggle()
                    } label: {
                        Image(systemName: "box.truck")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: 25)
                            .foregroundColor(Color("5amBlue"))
                    }

                }
            VStack {
                Text("Orders")
                    .modifier(RoundedTextLarge())
                ForEach(adminViewModel.orders, id: \.id) { order in
                    OrderCell(order: order)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .onTapGesture {
                            adminViewModel.currentOrder = order
                            isOrderViewShow.toggle()
                        }
                }
                Text("Custom orders")
                    .modifier(RoundedTextLarge())
                ForEach(adminViewModel.customOrders, id: \.id) { order in
                    OrderCell(order: order)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 8)
                        .onTapGesture {
                            adminViewModel.currentOrder = order
                            isOrderViewShow.toggle()
                        }
                }
            }
            .onAppear {
                adminViewModel.getOrders(custom: true)
                adminViewModel.getOrders(custom: false)
            }
            .sheet(isPresented: $isOrderViewShow) {
                let viewModel = OrderViewModel(order: adminViewModel.currentOrder)
                OrderView(viewModel: viewModel, profileViewModel: self.profileViewModel)
            }
            .sheet(isPresented: $isShowAddProductView) {
                AddProductView(viewModel: Photos())
            }
            .sheet(isPresented: $isShowDeliveryWays) {
                VStack {
                    DeliveryWaysView(viewModel: DeliveryViewModel())
                }
            }
        }
    }
}

/*
struct AdminPanel_Previews: PreviewProvider {
    static var previews: some View {
        AdminPanel()
    }
}

*/
