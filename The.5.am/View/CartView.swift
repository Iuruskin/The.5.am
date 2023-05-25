//
//  CartView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import SwiftUI

struct CartView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var dataModel: CartViewModel
    @StateObject var deliveryModel : DeliveryViewModel
    
    @State var deliveryPrice = 0
    @State var deliweryWay = ""
    
    @State var alert = false
    
    @State var alertMassage = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(dataModel.savedEntities) { position in
                    PositionCell(position: PositionModel(entities: position)!)
                }
                .onDelete(perform: dataModel.deletePosition)
            }
            
            HStack {
                
                Picker("Доставка", selection: $deliveryPrice) {
                    ForEach(deliveryModel.methods, id: \.price) { method in
                        Text("\(method.name) +\(method.price)₽")
                            .modifier(RoundedTextMedium())
                            .onChange(of: deliveryPrice) { newValue in
                                self.deliweryWay = deliveryModel.wayAndPrice[newValue] ?? "Ошибка в имени отправки"
                            }
                    }
                }
                .pickerStyle(.inline)
                .frame(height: 120)
            }
            HStack {
                Text("Итого:")
                    .modifier(RoundedTextMedium())
                Spacer()
                Text("\(dataModel.cost + deliveryPrice) ₽")
                    .modifier(RoundedTextMedium())
            }.padding(.horizontal)
            HStack {
                Button {
                    if let userId = AuthService.shared.currentUser?.uid {
                        if !dataModel.savedEntities.isEmpty {
                            var order = OrderModel(iserID: userId, date: Date(), status: OrderStatusEnum.new, custom: false, trackNumber: "", deliveryCost: self.deliveryPrice, deliveryWay: self.deliweryWay)
                            order.position = [PositionModel]()
                            for pos in dataModel.savedEntities {
                                order.position.append(PositionModel(entities: pos)!)
                            }
                            DataBaseServices.shared.setOrder(order: order, custom: false) { result in
                                switch result {
                                case .success(_):
                                    dataModel.deleteAllPosition()
                                    dataModel.savedEntities.removeAll()
                                    alertMassage = "Заказ успешно создан, для совершения оплаты пройдите в раздел \"Профиль\" и совершите оплату согласно инструкции"
                                    alert.toggle()
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            }
                        } else {
                            alertMassage = "Корзина пуста"
                            alert.toggle()
                        }
                    } else {
                        alertMassage = "Для совершения заказа необходимо авторизоваться"
                        alert.toggle()
                    }
                } label: {
                    Text("Заказать")
                        .modifier(RoundedTextLarge())
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(uiColor: .systemGreen))
                        .cornerRadius(15)
                }
                .padding(.horizontal)
                .padding(.bottom, 45)
            }
        }
        .alert(alertMassage, isPresented: $alert) {
            Text("Ok")
        }
        .onAppear {
            CartViewModel.shared.fetchPositions()
            deliveryModel.getDeliveryWays()
        }
    }
}

/*
 struct CartView_Previews: PreviewProvider {
 static var previews: some View {
 CartView(dataModel: CartViewModel.shared, deliveryModel: DeliveryViewModel())
 }
 }
 
 */
