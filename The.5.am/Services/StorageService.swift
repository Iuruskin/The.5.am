//
//  StorageService.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 12.04.2023.
//

import Foundation
import FirebaseStorage

class StorageServices {
    
    static let shared = StorageServices()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    private var productRef: StorageReference { storage.child("products") }
    
    private var customOrderef: StorageReference { storage.child("custom products") }
    
    
    func upload(id: String, imageSet: [Data?], custom: Bool, complition: @escaping (Result<String, Error>) -> Void) {
        
        var ref : StorageReference {
            custom ? customOrderef : productRef
        }
        let metadata = StorageMetadata(dictionary: ["content-type": "image-jpg"])
        metadata.contentType = "image-jpg"
        for data in imageSet {
            if let data = data {
                ref.child(id).child(UUID().uuidString).putData(data, metadata: metadata) { metadata, error in
                    guard let metadata = metadata else {
                        if let error = error {
                            complition(.failure(error))
                        }
                        return
                    }
                    complition(.success("\(metadata.size)"))
                }
            }
        }
    }
    
    func downloadProductImage(id: String, custom: Bool, complition: @escaping (Result<StorageListResult, Error>) -> Void) {
        var ref : StorageReference {
            custom ? customOrderef : productRef
        }
        
        ref.child(id).listAll { data, error in
            guard let data = data else {
                if let error = error {
                    complition(.failure(error))
                }
                return
            }
            complition(.success(data))
        }
    }
}
