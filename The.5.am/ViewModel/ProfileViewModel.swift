//
//  ProfileViewModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 03.04.2023.
//

import Foundation

class ProfileViewModel : ObservableObject {
    
    @Published var profile : MWUser
    @Published var orders : [OrderModel] = [OrderModel]()
    @Published var customOrders: [OrderModel] = [OrderModel]()
    @Published var isProfileView : Bool
    
    var currentOrder : OrderModel = OrderModel(iserID: "", date: Date(), status: .new, custom: false, trackNumber: "", deliveryCost: 0, deliveryWay: "")
    
    init(profile: MWUser) {
        self.profile = profile
        if AuthService.shared.currentUser != nil {
            self.isProfileView = true
        } else {
            self.isProfileView = false
        }
    }
    
    func setProfile() {
        DataBaseServices.shared.setProfile(user: self.profile) { result in
            switch result {
            case .success(let user):
                print(user.name)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getProfile() {
        DataBaseServices.shared.getProfile() { result in
            switch result {
            case .success(let user):
                self.profile = user
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func getOrders(custom: Bool) {
        DataBaseServices.shared.getOrders(userId: AuthService.shared.currentUser?.uid, custom: custom) { result in
            if custom == false {
                switch result {
                case .success(let order):
                    self.orders = order
                    for (index, order) in self.orders.enumerated() {
                        DataBaseServices.shared.getPositions(orderId: order.id, custom: custom) { result in
                            switch result {
                            case .success(let position):
                                self.orders[index].position = position
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            } else {
                switch result {
                case .success(let order):
                    self.customOrders = order
                    for (index, order) in self.customOrders.enumerated() {
                        DataBaseServices.shared.getPositions(orderId: order.id, custom: custom) { result in
                            switch result {
                            case .success(let position):
                                self.customOrders[index].position = position
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
}
