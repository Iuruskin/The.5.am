//
//  CatalogViewModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import Foundation


class CatalogViewModel : ObservableObject {
    
    static let shared = CatalogViewModel()
    
    
    
    @Published var hangers = [ProductModel]()
    @Published  var chainrings = [ProductModel]()
    @Published var other = [ProductModel]()
    @Published  var tools = [ProductModel]()
    @Published var light = [ProductModel]()
    
    
    func getProductsBySort() {
        DataBaseServices.shared.getProducts { result in
            var localHanger = [ProductModel]()
            var localChainring = [ProductModel]()
            var localOther = [ProductModel]()
            var localLight = [ProductModel]()
            var localTool = [ProductModel]()
            
            
            switch result {
            case .success(let position):
                for product in position {
                    if product.type == .hanger {
                        localHanger.append(product)
                    }
                    if product.type == .chainring {
                        localChainring.append(product)
                    }
                    if product.type == .other {
                        localOther.append(product)
                    }
                    if product.type == .tool {
                        localTool.append(product)
                    }
                    if product.type == .light {
                        localLight.append(product)
                    }
                }
                
                self.hangers = localHanger
                self.chainrings = localChainring
                self.tools = localTool
                self.light = localLight
                self.other = localOther
                
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
