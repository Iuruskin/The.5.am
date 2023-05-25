//
//  ProductCatalogView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import SwiftUI
import PhotosUI

struct ProductCell: View {
    
    @State var product : ProductModel
    @State var viewModel : ProductDetailViewModel
    @State var uiImage = UIImage(named: "defaultPicture")
    
    @State var photosData = Data()
    
    @StateObject var photos : Photos
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if !photosData.isEmpty {
                    Image(uiImage: UIImage(data: photosData)!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: screen.width * 0.45, height: screen.height * 0.30)
                        .cornerRadius(15)
                } else {
                    Image(uiImage: uiImage!)
                        .resizable()
                        .scaledToFill()
                        .frame(width: screen.width * 0.45, height: screen.height * 0.30)
                        .cornerRadius(15)
                }
                    
                ZStack {
                    gradient
                        .frame(width: screen.width * 0.45, height: 40, alignment: .bottom)
                        .cornerRadius(15)
                    HStack {
                        Text(product.title)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                        Text("\(product.price)₽")
                            .font(.system(size: 15, weight: .medium, design: .rounded))
                    }
                    .frame(width: screen.width * 0.45)
                }
                .offset(y: -30)
            }
        }
        .shadow(color: .gray, radius: 5)
        .onAppear {
            StorageServices.shared.downloadProductImage(id: product.id, custom: false) { result in
                switch result {
                case .success(let reference):
                    reference.items.first?.getData(maxSize: 2*1024*1024) { data, error in
                            if let data = data {
                                photosData = data
                            }
                        }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
    }
}



/*
struct ProductCatalogView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCell(product: ProductModel(id: UUID().uuidString, type: .hanger, title: "Петух 35", description: "охуенный петух", color: [.blue,.red], material: "7075", price: 850, weight: 200, countAvialable: [.red: 10,.blue: 15]))
    }
}

*/
