//
//  AddProductView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 11.04.2023.
//

import SwiftUI
import PhotosUI

struct AddProductView: View {
    
    @StateObject var viewModel : Photos
    
    @State private var image = UIImage(named: "defaultNewProduct")!
    @State var description : String = ""
    @State var title : String = ""
    @State var material : String = ""
    @State var price : Int?
    @State var weight : Int?
    @State var color = [avialableColor]()
    @State var type : TypeEnum = .hanger
    @State var countAvialable = [avialableColor: Int]()
   
    
    
    @State var count : Int = 0
    
    @State var alertPresented = false
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                Text("Новый товар")
                    .modifier(RoundedTextLarge())
                    .padding(.top)
                if !viewModel.selectedItems.isEmpty {
                    TabView {
                        ForEach(viewModel.selectedPhotoData, id: \.self) { photoData in
                            if let imageData = photoData {
                                let image = UIImage(data: imageData)
                                Image(uiImage: image!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(15)
                                    .padding(.horizontal, 70)
                            }
                        }
                    }
                    .frame(height: 400)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                }
                PhotosPicker(selection: $viewModel.selectedItems, maxSelectionCount: 8, matching: .images) {
                    Text("Выбрать фото")
                        .modifier(ProfileButtonStyle())
                }.onChange(of: viewModel.selectedItems) { newItems in
                    for newItem in newItems {
                        Task {
                            if let data = try? await newItem.loadTransferable(type: Data.self) {
                                viewModel.selectedPhotoData.append(data)
                            }
                        }
                    }
                }
                    
                Picker("Выберите тип товара", selection: $type) {
                    ForEach(TypeEnum.allCases, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                .frame(height: 150)
                .pickerStyle(.wheel)
                
                VStack {
                    TextField("Название продукта", text: $title)
                        .textFieldStyle(ProfileFixtFieldStule())
                        .padding(.horizontal)
                    TextField("Цена", value: $price, format: .number)
                        .textFieldStyle(ProfileFixtFieldStule())
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                    TextField("Вес", value: $weight, format: .number)
                        .textFieldStyle(ProfileFixtFieldStule())
                        .padding(.horizontal)
                        .keyboardType(.numberPad)
                    TextField("Материал", text: $material)
                        .textFieldStyle(ProfileFixtFieldStule())
                        .padding(.horizontal)
                    TextField("Описание продукта", text: $description)
                        .textFieldStyle(ProfileFixtFieldStule())
                        .padding(.horizontal)
                    Text("Наличие и цвета")
                        .modifier(RoundedTextLarge())
                }
            
                Stepper("\(count)", value: $count)
                    .padding(.horizontal, 20)
                    .modifier(RoundedTextMedium())
                    .foregroundColor(Color("5amBlue"))
                    ForEach(avialableColor.allCases, id: \.self) { newColor in
                       HStack {
                            Text(newColor.rawValue)
                               .modifier(RoundedTextMedium())
                               .padding(.horizontal)
                           Spacer()
                            Button {
                                self.color.append(newColor)
                                self.countAvialable[newColor] = count
                                self.count = 0
                            } label: {
                                Text("Добавить")
                                    .modifier(RoundedTextSmall())
                                    .foregroundColor(color.contains(newColor) ? .green : .red)
                                    .padding()
                                    .background(.bar)
                                    .cornerRadius(10)
                                Text("\(countAvialable[newColor] ?? 0)")
                                    .modifier(RoundedTextMedium())
                                    .foregroundColor(Color("5amBlue"))
                            
                        }
                            .padding(.horizontal, 30)
                    }
                }
                Button {
                    guard let intPrice = price else { return }
                    let product = ProductModel(id: UUID().uuidString, type: type, title: title, description: description, color: color, material: material, price: intPrice, weight: weight, countAvialable: countAvialable)
                    DataBaseServices.shared.setProduct(product: product, image: viewModel.selectedPhotoData, custom: false) { result in
                        switch result {
                        case .success(_):
                            dismiss.callAsFunction()
                        case .failure(let failure):
                            print(failure.localizedDescription)
                        }
                    }
                    
                } label: {
                    Text("Выгрузить товар")
                        .modifier(ProfileButtonStyle())
                }

            }
        }
    }
}

/*
struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView(viewModel: Photos())
    }
}
*/
