//
//  User.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 31.03.2023.
//

import Foundation

struct MWUser : Identifiable {
    var id: String
    var name: String
    var lastName: String
    var adress: String
    var phone: String
    var email: String
    var isAdmin = false
    
    var representation : [String: Any] {
        var repres = [String: Any]()
        repres[MWUserEnum.id.rawValue] = self.id
        repres[MWUserEnum.name.rawValue] = self.name
        repres[MWUserEnum.lastName.rawValue] = self.lastName
        repres[MWUserEnum.adress.rawValue] = self.adress
        repres[MWUserEnum.phone.rawValue] = self.phone
        repres[MWUserEnum.isAdmin.rawValue] = self.isAdmin
        repres[MWUserEnum.email.rawValue] = self.email
        return repres
    }
}



