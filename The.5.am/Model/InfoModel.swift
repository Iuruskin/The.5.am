//
//  InfoModel.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 20.05.2023.
//

import Foundation
import Firebase

struct InfoModel {
    
    var email : String
    var phone : String
    var telegram : String
    var howToPay : String
    var about : String
    var instagram : String
    var fio : String
    var iban : String
    var fioEng : String
    var privacy : String
    
    init(email: String, phone: String, telegram: String, howToPay: String, about: String, instagram: String, fio: String, iban: String, fioEng : String, privacy: String) {
        self.email = email
        self.phone = phone
        self.telegram = telegram
        self.howToPay = howToPay
        self.about = about
        self.instagram = instagram
        self.fio = fio
        self.iban = iban
        self.fioEng = fioEng
        self.privacy = privacy
    }
    
    init? (data: [String: Any]) {
        guard let email = data[infoEnum.email.rawValue] as? String else { return nil }
        guard let phone = data[infoEnum.phone.rawValue] as? String else { return nil }
        guard let telegram = data[infoEnum.telegram.rawValue] as? String else { return nil }
        guard let howToPay = data[infoEnum.howToPay.rawValue] as? String else { return nil }
        guard let about = data[infoEnum.about.rawValue] as? String else { return nil }
        guard let instagram = data[infoEnum.instagram.rawValue] as? String else { return nil }
        guard let fio = data[infoEnum.fio.rawValue] as? String else { return nil }
        guard let iban = data[infoEnum.iban.rawValue] as? String else { return nil }
        guard let fioEng = data[infoEnum.fioEng.rawValue] as? String else { return nil }
        guard let privacy = data[infoEnum.privacy.rawValue] as? String else { return nil }
        
        
        self.email = email
        self.phone = phone
        self.telegram = telegram
        self.howToPay = howToPay
        self.about = about
        self.instagram = instagram
        self.fio = fio
        self.iban = iban
        self.fioEng = fioEng
        self.privacy = privacy
    }
}
