//
//  ProductDetailView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import SwiftUI

struct ProductDetailView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @State var viewModel : ProductDetailViewModel
    @State var color : avialableColor = .black
    @State var count = 1
    @Environment (\.dismiss) var dismiss
    @State var photos = [Data?]()
    @State var sheet = false
    @State var sheetText = ""
    
    func getAvialableCountColor() -> Int {
        var newValue = 0
        for value in viewModel.product.countAvialable {
            if value.key == color {
                newValue = value.value
            }
        }
        return newValue
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack {
                    TabView {
                        if !photos.isEmpty {
                            ForEach(photos, id: \.self) { photoData in
                                if let photoData = photoData {
                                    let image = UIImage(data: photoData)
                                    Image(uiImage: image!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(15)
                                        .padding(.horizontal, 8)
                                }
                            }
                        }
                    }
                    .frame(height: 500)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    HStack {
                        Text(viewModel.product.title)
                            .modifier(RoundedTextMedium())
                        Spacer()
                        Text("\(viewModel.product.price) ₽")
                            .modifier(RoundedTextMedium())
                    }
                    
                    HStack {
                        Picker("Выберите цвет" ,selection: $color) {
                            ForEach(viewModel.product.color, id: \.self) { text in
                                Text(text.rawValue)
                                    .modifier(RoundedTextMedium())
                            }
                        }
                        .padding(.vertical)
                        .pickerStyle(.segmented)
                    }
                    
                    if getAvialableCountColor() > 0 {
                        Stepper("Колличество: \(count)", value: $count, in: 1...getAvialableCountColor())
                            .modifier(RoundedTextMedium())
                        
                        Button {
                            let position = PositionModel(id: UUID().uuidString, product: viewModel.product, color: color, count: count)
                            CartViewModel.shared.addPosition(positions: position)
                            dismiss.callAsFunction()
                        } label: {
                            ZStack {
                                gradient
                                Text("В корзину")
                                    .modifier(RoundedTextLarge())
                                    .foregroundColor(.black)
                            }
                            .modifier(ButtonModifire())
                        }
                    } else {
                        HStack {
                            Stepper("Колличество \(count)", value: $count, in: 0...100)
                                .modifier(RoundedTextMedium())
                        }
                        Button {
                            if let userId = AuthService.shared.currentUser?.uid {
                                let product = ProductModel(id: viewModel.product.id, type: viewModel.product.type, title: viewModel.product.title, description: viewModel.product.description, color: [color], material: viewModel.product.material, price: viewModel.product.price, weight: viewModel.product.weight, countAvialable: viewModel.product.countAvialable)
                                DataBaseServices.shared.setProduct(product: product, image: [nil], custom: true) { result in
                                    switch result {
                                    case .success(let product):
                                        let position = PositionModel(id: UUID().uuidString, product: product, color: color, count: self.count)
                                        let order = OrderModel(iserID: userId, position: [position], date: Date(), status: .new, custom: true, trackNumber: "", deliveryCost: 0, deliveryWay: "Noway")
                                        DataBaseServices.shared.setOrder(order: order, custom: order.custom) { result in
                                            switch result {
                                            case .success(_):
                                                sheetText = "Запрос успешно отправлен, мы свяжемся с вами в ближайшее время"
                                                sheet.toggle()
                                            case .failure(let error):
                                                print(error.localizedDescription)
                                            }
                                        }
                                        
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        } label: {
                            ZStack {
                                gradient
                                Text("Отправить запрос")
                                    .modifier(RoundedTextLarge())
                                    .foregroundColor(.black)
                            }
                            .modifier(ButtonModifire())
                        }
                    }
                    Text("Материал: \(viewModel.product.material)")
                        .modifier(RoundedTextMedium())
                        .padding(.bottom)
                    if let weight = viewModel.product.weight {
                        Text("Вес: \(weight) гр.")
                            .modifier(RoundedTextMedium())
                            .padding(.bottom)
                    }
                    Text(viewModel.product.description)
                        .modifier(RoundedTextMedium())
                }
            }.padding()
        }.onAppear {
            StorageServices.shared.downloadProductImage(id: viewModel.product.id, custom: false) { result in
                switch result {
                case .success(let reference):
                    for data in reference.items {
                        data.getData(maxSize: 200*10024*10024) { data, error in
                            if let data = data {
                                self.photos.append(data)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        .alert(sheetText, isPresented: $sheet) {
            Text("Ok")
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "arrowshape.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
        }
    }
}





struct ProductDetailView_Previews: PreviewProvider {
    
    
    static var previews: some View {
        ProductDetailView(viewModel: ProductDetailViewModel(product: ProductModel(id: UUID().uuidString, type: .hanger, title: "петух 23", description: "", color: [.blue, .red, .purple], material: "fdg", price: 450,weight: 43 ,countAvialable: [.red: 3, .blue : 5])))
    }
}
