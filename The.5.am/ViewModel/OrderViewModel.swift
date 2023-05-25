//
//  OrderViewModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 06.04.2023.
//

import Foundation
import SwiftUI
import UIKit

class OrderViewModel : ObservableObject {
    @Published var order : OrderModel
    @Published var user = MWUser(id: "", name: "", lastName: "", adress: "", phone: "", email: "")
    
    
    init(order: OrderModel) {
        self.order = order
    }
    
    
    func getUserData() {
        DataBaseServices.shared.getProfile(userID: order.userID) { result in
            switch result {
            case .success(let user):
                self.user = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func writeToPhotoAlbum(imageData: [Data?]) {
        for data in imageData {
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            UIImageWriteToSavedPhotosAlbum(image, nil, #selector(saveCompleted), nil)
        }
    }
    
    @objc func saveCompleted(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print(error?.localizedDescription as Any)
    }
    
}
