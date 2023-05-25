//
//  DataBaseService.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 02.04.2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class DataBaseServices {
    
    static let shared = DataBaseServices()
    
    private let dataBase = Firestore.firestore()
    
    private var usersRef : CollectionReference {
        dataBase.collection("users")
    }
    
    private var orderRef: CollectionReference {
        dataBase.collection("orders")
    }
    
    private var productRef: CollectionReference {
        dataBase.collection("products")
    }
    
    private var deliveryWaysRef: CollectionReference {
        dataBase.collection("delivery")
    }
    
    private var customOrderProductRef: CollectionReference {
        dataBase.collection("custom products")
    }
    
    private var customOrderRef : CollectionReference {
        dataBase.collection("custom orders")
    }
    
    private var infoRef : CollectionReference {
        dataBase.collection("info")
    }
    
    func setUser(user: MWUser, complition: @escaping (Result<MWUser, Error>) -> ()) {
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                complition(.failure(error))
            } else {
                complition(.success(user))
            }
        }
    }
    
    func setProfile(user: MWUser, complition: @escaping (Result<MWUser, Error>) -> Void) {
        usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                complition(.failure(error))
            } else {
                complition(.success(user))
            }
        }
    }
    
    func setOrder(order: OrderModel, custom: Bool, complition: @escaping (Result<OrderModel, Error>) -> Void) {
        var ref : CollectionReference {
            custom ? customOrderRef : orderRef
        }
        
        ref.document(order.id).setData(order.representation) { error in
            if let error = error {
                complition(.failure(error))
            } else {
                self.setPositions(to: order.id, custom: custom, positions: order.position) { result in
                    switch result {
                    case .success(_):
                        complition(.success(order))
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    
    func getProfile(userID: String? = nil, complition: @escaping (Result<MWUser, Error>) -> Void) {
        usersRef.document(userID != nil ? userID! : AuthService.shared.currentUser!.uid).getDocument { docSnap, error in
            guard let snap = docSnap else { return }
            guard let data = snap.data() else { return }
            guard let userName = data[MWUserEnum.name.rawValue] as? String else { return }
            guard let lastName = data[MWUserEnum.lastName.rawValue] as? String else { return }
            guard let phone = data[MWUserEnum.phone.rawValue] as? String else { return }
            guard let adress = data[MWUserEnum.adress.rawValue] as? String else { return }
            guard let id = data[MWUserEnum.id.rawValue] as? String else { return }
            guard let email = data[MWUserEnum.email.rawValue] as? String else { return }
            guard let isAdmin = data[MWUserEnum.isAdmin.rawValue] as? Bool else { return }
            
            complition(.success(MWUser(id: id, name: userName, lastName: lastName, adress: adress, phone: phone, email: email, isAdmin: isAdmin)))
        }
    }
    
    func getDeliveryWays(complition: @escaping (Result<[DeliveryModel], Error>) -> Void) {
        self.deliveryWaysRef.order(by: "price").getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var deliveryWays = [DeliveryModel]()
                for doc in qSnap.documents {
                    if let way = DeliveryModel(doc: doc) {
                        deliveryWays.append(way)
                    }
                    
                }
                complition(.success(deliveryWays))
            } else {
                if let error = error {
                    complition(.failure(error))
                }
            }
        }
    }
    
    
    func getOrders(userId: String?, custom: Bool, complition: @escaping (Result<[OrderModel], Error>) -> Void) {
        var ref : CollectionReference {
            custom ? customOrderRef : orderRef
        }
        
        ref.order(by: "date", descending: true).getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var orders = [OrderModel]()
                
                for doc in qSnap.documents {
                    // решение не очень хорошее так как расходуются ресурсы firebase
                    if let userId = userId {
                        if let order = OrderModel(doc: doc), order.userID == userId {
                            orders.append(order)
                        }
                    } else {
                        if let order = OrderModel(doc: doc) {
                            orders.append(order)
                        }
                    }
                }
                complition(.success(orders))
            } else {
                if let error = error {
                    complition(.failure(error))
                }
            }
        }
    }
    
    
    
    
    func getInfo(complition: @escaping (Result<InfoModel, Error>) -> Void) {
        infoRef.document("tNskWoPO2OqsZjBCI6QE").getDocument { docSnap, error in
            guard let snap = docSnap else { return }
            guard let data = snap.data() else { return }
            guard let infoModel = InfoModel(data: data) else { return }
            complition(.success(infoModel))
        }
    }
    
    func getPositions(orderId: String, custom: Bool, complition: @escaping (Result<[PositionModel], Error>) -> Void) {
        var positionsRef : CollectionReference {
            custom ? customOrderRef.document(orderId).collection("positions") : orderRef.document(orderId).collection("positions")
        }
        
        positionsRef.getDocuments { qSnap, error in
            if let qSnap = qSnap {
                var positions = [PositionModel]()
                
                for doc in qSnap.documents {
                    if let position = PositionModel(doc: doc) {
                        positions.append(position)
                    }
                }
                complition(.success(positions))
            } else if let error = error {
                complition(.failure(error))
            }
        }
    }
    
    
    func getProducts(complition: @escaping (Result<[ProductModel], Error>) -> Void) {
        self.productRef.getDocuments { qSnap, error in
            guard let qSnap = qSnap else {
                if let error = error {
                    complition(.failure(error))
                }
                return
            }
            let docs = qSnap.documents
            var products = [ProductModel]()
            for doc in docs {
                guard let product = ProductModel(doc: doc) else { return }
                products.append(product)
                complition(.success(products))
            }
        }
    }
    
    func deleteDeliveryWay(way: DeliveryModel, complition : @escaping (Result<DeliveryModel, Error>) -> Void) {
        deliveryWaysRef.document(way.id).delete()
    }
    
    func setPositions(to orderId: String, custom: Bool, positions: [PositionModel], complition: @escaping (Result<[PositionModel], Error>) -> Void) {
        var positionRef : CollectionReference { custom ? customOrderRef.document(orderId).collection("positions") : orderRef.document(orderId).collection("positions")
        }
        for position in positions {
            positionRef.document(position.id).setData(position.representation)
        }
        complition(.success(positions))
    }
    
    
    func setDeliveryWay(way: DeliveryModel, complition: @escaping(Result<DeliveryModel, Error>) -> Void) {
        deliveryWaysRef.document(way.id).setData(way.representation) { error in
            if let error = error {
                complition(.failure(error))
            } else {
                complition(.success(way))
            }
        }
    }
    
    func setCustomProduct(product: ProductModel, complirion: @escaping(Result<ProductModel, Error>) -> Void) {
        customOrderProductRef.document(product.id).setData(product.representation) { error in
            if let error = error {
                complirion(.failure(error))
            } else {
                complirion(.success(product))
            }
        }
    }
    
    
    func setProduct(product: ProductModel, image: [Data?], custom: Bool, complition: @escaping (Result<ProductModel, Error>) -> Void) {
        StorageServices.shared.upload(id: product.id, imageSet: image, custom: custom) { result in
            switch result {
            case .success(let data):
                print(data.count)
            case .failure(let failure):
                complition(.failure(failure))
            }
        }
        var ref : CollectionReference {
            custom ? self.customOrderProductRef : self.productRef
        }
        ref.document(product.id).setData(product.representation) { error in
            if let error {
                complition(.failure(error))
            } else {
                complition(.success(product))
            }
        }
    }
    
    
}
