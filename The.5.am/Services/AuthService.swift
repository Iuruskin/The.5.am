//
//  AuthService.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 31.03.2023.
//

import Foundation
import FirebaseAuth
import Firebase

class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    private let auth = Auth.auth()
    
    var currentUser : User? {
        return auth.currentUser
    }
    
    
    func resetPassword(email: String, complition: @escaping (Result<String, Error>) -> Void) {
        auth.sendPasswordReset(withEmail: email)  { error in
            if let error = error {
                complition(.failure(error))
            } else {
                complition(.success(email))
            }
        }
    }
    
    
    func createNewUser(email: String, password: String, phone: String, adress: String, name: String, lastName: String, complition: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let result = result {
                let mWuser = MWUser(id: result.user.uid, name: name, lastName: lastName, adress: adress, phone: phone, email: email)
                DataBaseServices.shared.setUser(user: mWuser) { resultDataBase in
                    switch resultDataBase {
                    case .success(_):
                        complition(.success(result.user))
                    case .failure(let error):
                        complition(.failure(error))
                    }
                }
                complition(.success(result.user))
            } else {
                if let error = error {
                    complition(.failure(error))
                }
            }
        }
    }
    
    func signIn(email: String, password: String, copmlition: @escaping (Result<User, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { result, error in
            if let result = result {
                copmlition(.success(result.user))
            } else if let error = error {
                copmlition(.failure(error))
            }
        }
        
        
    }
    
    func signOut() {
        try! auth.signOut()
    }
    
}
