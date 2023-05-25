//
//  OrderView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 10.04.2023.
//

import SwiftUI

struct OrderView: View {
    
    @StateObject var viewModel : OrderViewModel
    @StateObject var profileViewModel : ProfileViewModel
    @State var downloaded = false
    
    
    @State var photos = [Data?]()
    
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                VStack {
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Имя: \(viewModel.user.name)")
                                .modifier(RoundedTextMedium())
                            Text("Фамилия: \(viewModel.user.lastName)")
                                .modifier(RoundedTextMedium())
                            Text("Телефон: \(viewModel.user.phone)")
                                .modifier(RoundedTextMedium())
                            Text("Адрес доставки: \(viewModel.user.adress)")
                                .modifier(RoundedTextMedium())
                            if profileViewModel.profile.isAdmin {
                                Picker(selection: $viewModel.order.status) {
                                    ForEach(OrderStatusEnum.allCases, id: \.self) { value in
                                        Text(value.rawValue)
                                            .tag(value)
                                    }
                                } label: {
                                    Text("Статус заказа")
                                }
                                .pickerStyle(.segmented)
                                .onChange(of: viewModel.order.status) { status in
                                    DataBaseServices.shared.setOrder(order: viewModel.order, custom: viewModel.order.custom) { result in
                                        switch result {
                                        case .success(let order):
                                            print(order.statusStr)
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                        }
                                    }
                                }
                                TextField("TrackNumber", text: $viewModel.order.trackNumber)
                                    .textFieldStyle(ProfileFixtFieldStule())
                                    .onSubmit {
                                        DataBaseServices.shared.setOrder(order: viewModel.order, custom: viewModel.order.custom) { result in
                                            switch result {
                                            case .success(let order):
                                                print(order.statusStr)
                                            case .failure(let error):
                                                print(error.localizedDescription)
                                            }
                                        }
                                    }
                            } else {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Статус заказа: \(viewModel.order.statusStr)")
                                        .modifier(RoundedTextMedium())
                                    Text(viewModel.order.trackNumber != "" ? "Трек номер: \(viewModel.order.trackNumber)" : "Трек номер еще не присвоен.")
                                        .modifier(RoundedTextMedium())
                                }
                            }
                        }.padding()
                    }
                }
                if !photos.isEmpty {
                    TabView {
                        ForEach(photos, id: \.self) { photoData in
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
                    .frame(height: 300)
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    
                    
                    if profileViewModel.profile.isAdmin && !photos.isEmpty {
                        HStack {
                            Button {
                                viewModel.writeToPhotoAlbum(imageData: photos)
                                downloaded.toggle()
                            } label: {
                                Text("Скачать все фото")
                                    .modifier(ProfileButtonStyle())
                            }
                        }.frame(maxWidth: .infinity)
                    }
                }
                
                Divider()
                    ForEach(viewModel.order.position, id: \.id) { position in
                        VStack {
                        PositionCell(position: position)
                            if viewModel.order.custom {
                                Text(position.product.description)
                                    .modifier(RoundedTextMedium())
                            }
                                Divider()
                        }.padding(.horizontal)
                    }
                    if profileViewModel.profile.isAdmin && viewModel.order.custom {
                        HStack {
                            Image(systemName: "envelope")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                            TextField("Способ доставки:", text: $viewModel.order.deliveryWay)
                                .textFieldStyle(ProfileFixtFieldStule())
                        }.padding(.horizontal)
                        HStack {
                            Image(systemName: "banknote")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                            TextField("Стоимость", value: $viewModel.order.position.first!.product.price, format: .number)
                                .textFieldStyle(ProfileFixtFieldStule())
                            Text("₽/шт")
                                .modifier(RoundedTextMedium())
                        }.padding(.horizontal)
                        HStack {
                            Image(systemName: "box.truck")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30)
                            TextField("Стоимость доставки", value: $viewModel.order.deliveryCost, format: .number)
                                .textFieldStyle(ProfileFixtFieldStule())
                            Text("₽")
                                .modifier(RoundedTextMedium())
                        }.padding(.horizontal)
                    } else {
                        Text("Способ доставки: \(viewModel.order.deliveryWay)")
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .modifier(RoundedTextMedium())
                        Text("Доставка: \(viewModel.order.deliveryCost) ₽")
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .modifier(RoundedTextMedium())
                        Text("Итого: \(viewModel.order.cost + viewModel.order.deliveryCost) ₽")
                            .padding(.horizontal)
                            .padding(.vertical, 4)
                            .modifier(RoundedTextMedium())
                    }
                
            }
        }
        .onAppear {
            viewModel.getUserData()
            if profileViewModel.profile.isAdmin {
                if let id = viewModel.order.position.first?.id {
                    print(id)
                    StorageServices.shared.downloadProductImage(id: id, custom: true) { result in
                        switch result {
                        case .success(let reference):
                            for data in reference.items {
                                data.getData(maxSize: 200*10024*10024) { data, error in
                                    if let data = data {
                                        self.photos.append(data)
                                        print(photos.count)
                                    }
                                    if let error = error {
                                        print(error.localizedDescription)
                                    }
                                }
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.order.deliveryCost) { newValue in
            DataBaseServices.shared.setOrder(order: viewModel.order, custom: true) { result in
                switch result {
                case .success(let success):
                    print(success.id)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }.onChange(of: viewModel.order.cost) { newValue in
            DataBaseServices.shared.setOrder(order: viewModel.order, custom: true) { result in
                switch result {
                case .success(let success):
                    print(success.id)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        .alert("Фотографии cохранены", isPresented: $downloaded) {
            Text("Ok")
        }
    }
}









//import SwiftUI
//
//struct OrderView: View {
//
//    @StateObject var viewModel : OrderViewModel
//    @StateObject var profileViewModel : ProfileViewModel
//    @State var downloaded = false
//
//
//    @State var photos = [Data?]()
//
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            VStack {
//                HStack {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Имя: \(viewModel.user.name)")
//                            .modifier(RoundedTextMedium())
//                        Text("Фамилия: \(viewModel.user.lastName)")
//                            .modifier(RoundedTextMedium())
//                        Text("Телефон: \(viewModel.user.phone)")
//                            .modifier(RoundedTextMedium())
//                        Text("Адрес доставки: \(viewModel.user.adress)")
//                            .modifier(RoundedTextMedium())
//                    }.padding()
//
//                    if profileViewModel.profile.isAdmin && !photos.isEmpty {
//                        Button {
//                            viewModel.writeToPhotoAlbum(imageData: photos)
//                            downloaded.toggle()
//                        } label: {
//                            Image(systemName: "globe")
//                        }
//                    }
//                }
//                if profileViewModel.profile.isAdmin {
//                    Picker(selection: $viewModel.order.status) {
//                        ForEach(OrderStatusEnum.allCases, id: \.self) { value in
//                            Text(value.rawValue)
//                                .tag(value)
//                        }
//                    } label: {
//                        Text("Статус заказа")
//                    }
//                    .pickerStyle(.segmented)
//                    .onChange(of: viewModel.order.status) { status in
//                        DataBaseServices.shared.setOrder(order: viewModel.order, custom: viewModel.order.custom) { result in
//                            switch result {
//                            case .success(let order):
//                                print(order.statusStr)
//                            case .failure(let error):
//                                print(error.localizedDescription)
//                            }
//                        }
//                    }
//                    TextField("TrackNumber", text: $viewModel.order.trackNumber)
//                        .onSubmit {
//                            DataBaseServices.shared.setOrder(order: viewModel.order, custom: viewModel.order.custom) { result in
//                                switch result {
//                                case .success(let order):
//                                    print(order.statusStr)
//                                case .failure(let error):
//                                    print(error.localizedDescription)
//                                }
//                            }
//                        }
//                } else {
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("Статус заказа: \(viewModel.order.statusStr)")
//                            .modifier(RoundedTextMedium())
//                        Text(viewModel.order.trackNumber != "" ? "Трек номер: \(viewModel.order.trackNumber)" : "Трек номер еще не присвоен.")
//                            .modifier(RoundedTextMedium())
//                    }.padding()
//                }
//            }
//            if !photos.isEmpty {
//                TabView {
//                    ForEach(photos, id: \.self) { photoData in
//                        if let imageData = photoData {
//                            let image = UIImage(data: imageData)
//                            Image(uiImage: image!)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .cornerRadius(15)
//                                .padding(.horizontal, 70)
//                        }
//                    }
//                }
//                .frame(height: 300)
//                .tabViewStyle(.page(indexDisplayMode: .always))
//            }
//            List {
//                ForEach(viewModel.order.position, id: \.id) { position in
//                    PositionCell(position: position)
//                    if viewModel.order.custom {
//                        Text(position.product.description)
//                    }
//                }
//                if profileViewModel.profile.isAdmin && viewModel.order.custom {
//                    TextField("Стоимость доставки", value: $viewModel.order.deliveryCost, format: .number)
//                    TextField("Стоимость", value: $viewModel.order.position.first!.product.price, format: .number)
//                } else {
//                    Text("Доставка: \(viewModel.order.deliveryCost) ₽")
//                        .modifier(RoundedTextMedium())
//                    Text("Итого \(viewModel.order.cost + viewModel.order.deliveryCost) ₽")
//                        .modifier(RoundedTextMedium())
//                }
//            }
//        }
//        .onAppear {
//            viewModel.getUserData()
//            if profileViewModel.profile.isAdmin {
//                if let id = viewModel.order.position.first?.id {
//                    print(id)
//                    StorageServices.shared.downloadProductImage(id: id, custom: true) { result in
//                        switch result {
//                        case .success(let reference):
//                            for data in reference.items {
//                                data.getData(maxSize: 200*10024*10024) { data, error in
//                                    if let data = data {
//                                        self.photos.append(data)
//                                        print(photos.count)
//                                    }
//                                    if let error = error {
//                                        print(error.localizedDescription)
//                                    }
//                                }
//                            }
//                        case .failure(let error):
//                            print(error.localizedDescription)
//                        }
//                    }
//                }
//            }
//        }
//        .onChange(of: viewModel.order.deliveryCost) { newValue in
//            DataBaseServices.shared.setOrder(order: viewModel.order, custom: true) { result in
//                switch result {
//                case .success(let success):
//                    print(success.id)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }.onChange(of: viewModel.order.cost) { newValue in
//            DataBaseServices.shared.setOrder(order: viewModel.order, custom: true) { result in
//                switch result {
//                case .success(let success):
//                    print(success.id)
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
//        .alert("Фотографии cохранены", isPresented: $downloaded) {
//            Text("Ok")
//        }
//    }
//}
//
//
