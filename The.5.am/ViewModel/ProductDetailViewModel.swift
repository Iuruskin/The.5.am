//
//  ProductDetailViewModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import Foundation
import UIKit
import PhotosUI
import _PhotosUI_SwiftUI

class ProductDetailViewModel : ObservableObject {
    
    @Published var product : ProductModel
    @Published var count : Int = 1
    @Published var image = UIImage(named: "defaultPicture")
    @Published var imageSetData = [Data?]()
    
    
    init(product: ProductModel) {
        self.product = product
        self.count = count
        self.image = image
        self.imageSetData = imageSetData
    }
    
    
    
    func getImage() {
        StorageServices.shared.downloadProductImage(id: product.id, custom: false) { result in
            switch result {
            case .success(let reference):
                for data in reference.items {
                    data.getData(maxSize: 200*10024*10024) { data, error in
                        if let data = data {
                            self.imageSetData.append(data)
                        }
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
