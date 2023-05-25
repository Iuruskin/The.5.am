//
//  DeliveryViewModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 12.05.2023.
//

import Foundation

class DeliveryViewModel: ObservableObject {
    @Published var methods = [DeliveryModel]()
    
    var wayAndPrice : [Int: String] {
        var result : [Int: String] = [:]
            for i in methods {
                result[i.price] = i.name
            }
            return result
        }
    
    func getDeliveryWays() {
        DataBaseServices.shared.getDeliveryWays { result in
            switch result {
            case .success(let ways):
                self.methods = ways
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteWays(ofsets: IndexSet) {
        guard let index = ofsets.first else { return }
        DataBaseServices.shared.deleteDeliveryWay(way: methods[index]) { result in
            switch result {
            case .success(let success):
                print(success.name)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
}
