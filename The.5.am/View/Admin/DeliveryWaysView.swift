//
//  DeliveryWaysView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 12.05.2023.
//

import SwiftUI

struct DeliveryWaysView: View {
    
   @StateObject var viewModel : DeliveryViewModel
    @State var name = ""
    @State var price = 0
    
    var body: some View {
        VStack {
            TextField("Название способа доставки", text: $name)
                .textFieldStyle(ProfileFixtFieldStule())
                .padding(.top)
                .padding(.horizontal)
            HStack {
                Image(systemName: "banknote")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 25)
                TextField("Стоимость", value: $price, format: .number)
                    .textFieldStyle(ProfileFixtFieldStule())
                Text("₽")
            }.padding()
            Button {
                DataBaseServices.shared.setDeliveryWay(way: DeliveryModel(name: self.name, price: self.price)) { result in
                    switch result {
                    case .success(let way):
                       viewModel.methods.append(way)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Добавить способ доставки")
                    .modifier(ProfileButtonStyle())
            }

            List {
                ForEach(viewModel.methods, id: \.name) { method in
                    HStack {
                        Text(method.name)
                            .modifier(RoundedTextMedium())
                        Text("\(method.price)")
                            .modifier(RoundedTextMedium())
                    }
                }.onDelete(perform: viewModel.deleteWays)
            }
        }.onAppear {
            viewModel.getDeliveryWays()
        }
    }
}



/*
struct DeliveryWaysView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryWaysView(viewModel: DeliveryViewModel())
    }
}
*/
