//
//  AdmimOrdersViewModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 10.04.2023.
//

import Foundation

class AdminOrdersViewModel : ObservableObject {
    @Published var orders = [OrderModel]()
    @Published var customOrders = [OrderModel]()
    
    var currentOrder = OrderModel(iserID: "", date: Date(), status: .new, custom: false, trackNumber: "", deliveryCost: 0, deliveryWay: "")
    
    func getOrders(custom: Bool) {
        DataBaseServices.shared.getOrders(userId: nil, custom: custom) { result in
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
