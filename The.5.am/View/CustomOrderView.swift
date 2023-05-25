//
//  CustomOrderView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import SwiftUI
import PhotosUI

struct CustomOrderView: View {
    
    @State var title = ""
    @State var description = ""
    @State var count = 0
    @State var iRequest = ""
    @State var color : avialableColor
    @State var asap = false
    @State var asapView = false
    @State var material = ""
    
    @State var sheet = false
    @State var sheetText = ""
    @StateObject var photos : Photos
    
    
    
    var body: some View {
        ScrollView(.vertical) {
            Text("Custom order")
                .modifier(RoundedTextLarge())
                .padding(.bottom, 30)
            TextField("Название детали", text: $title)
                .textFieldStyle(ProfileFixtFieldStule())
            TextField("Описание запроса", text: $description)
                .textFieldStyle(ProfileFixtFieldStule())
            TextField("Материал", text: $material)
                .textFieldStyle(ProfileFixtFieldStule())
            HStack {
                Stepper(value: $count) {
                    Text("Колличество: \(count)")
                        .modifier(RoundedTextMedium())
                        .padding(.vertical)
                }
            }
            Picker(selection: $color) {
                ForEach(avialableColor.allCases, id: \.self) { color in
                    Text(color.rawValue)
                        .modifier(RoundedTextMedium())
                }
            } label: {
                Text("Выбкрите цвет")
            }
            .pickerStyle(.wheel)
            .frame(height: 100)
            
            HStack {
                Toggle("Срочный заказ:", isOn: $asap)
                    .modifier(RoundedTextMedium())
                Button {
                    asapView.toggle()
                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .foregroundColor(Color("5amBlue"))
                        .frame(width: 30, height: 30)
                        .padding(.leading)
                }
            }
            PhotosPicker(selection: $photos.selectedItems,maxSelectionCount: 6 ,matching: .images) {
                ZStack {
                    gradient
                    HStack {
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 30)
                            .foregroundColor(.black)
                        Text("Прикрепить Фото")
                            .modifier(RoundedTextMedium())
                            .foregroundColor(.black)
                    }
                }.modifier(ButtonModifire())
                
            }.onChange(of: photos.selectedItems) { newItems in
                var selectedPhoto = [Data]()
                photos.selectedPhotoData.removeAll()
                for newItem in newItems {
                    Task {
                        if let data = try? await newItem.loadTransferable(type: Data.self) {
                            selectedPhoto.append(data)
                            photos.selectedPhotoData = selectedPhoto
                        }
                    }
                }
            }
            if !photos.selectedPhotoData.isEmpty {
                TabView {
                    ForEach(photos.selectedPhotoData, id: \.self) { imageData in
                        if let imageData = imageData {
                            
                            Image(uiImage: UIImage(data: imageData)!)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(15)
                        }
                    }
                    
                }
                .frame(height: 300)
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
            
            Button {
                if let userId = AuthService.shared.currentUser?.uid {
                    let id = UUID().uuidString
                    let product = ProductModel(id: id, type: .other, title: title, description: asap ? "Cрочый заказ " + description : description, color: [color], material: material, price: 0, weight: 0, countAvialable: [.black: 0])
                    DataBaseServices.shared.setProduct(product: product, image: photos.selectedPhotoData, custom: true) { result in
                        switch result {
                        case .success(let product):
                            if AuthService.shared.currentUser?.uid != nil {
                                let position = PositionModel(id: id, product: product, color: color, count: count)
                                let order = OrderModel(iserID: userId,position: [position], date: Date(), status: .new, custom: true, trackNumber: "", deliveryCost: 0, deliveryWay: "")
                                DataBaseServices.shared.setOrder(order: order, custom: true) { result in
                                    switch result {
                                    case .success(_):
                                        self.sheetText = "Запрос успешно отправлен, мы свяжемся с вами в ближайшее время"
                                        self.sheet.toggle()
                                        self.title = ""
                                        self.description = ""
                                        self.material = ""
                                        self.count = 0
                                        self.asap = false
                                        photos.selectedPhotoData.removeAll()
                                        photos.selectedItems.removeAll()
                                        
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    self.sheetText = "Для совершения заказа необходимо авторизоваться"
                    self.sheet.toggle()
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
        .padding()
        .sheet(isPresented: $asapView) {
            Text("Срочный заказ")
        }
        .alert(sheetText, isPresented: $sheet) {
            Text("Ok")
        }
    }
}

struct CustomOrderView_Previews: PreviewProvider {
    static var previews: some View {
        CustomOrderView(color: .black, photos: Photos())
    }
}
