//
//  HowToPayView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 19.05.2023.
//

import SwiftUI

struct HowToPayView: View {
    
    @State var dataModel : InfoModel
    
    var body: some View {
        VStack {
            Text("Способы оплаты")
                .modifier(RoundedTextLarge())
                .padding()
            Text(dataModel.howToPay)
                .modifier(RoundedTextMedium())
                .padding()
            HStack {
                Text("СПБ:")
                    .modifier(RoundedTextMedium())
                Text(dataModel.phone)
                    .modifier(RoundedTextMedium())
            }
            .padding()
            
            HStack {
                Text("IBAN:")
                    .modifier(RoundedTextMedium())
                Text(dataModel.iban)
                    .modifier(RoundedTextMedium())
                    
            }
            .padding()
            
            HStack {
                Text("Zelle:")
                    .modifier(RoundedTextMedium())
                Text(dataModel.email)
                    .modifier(RoundedTextMedium())
            }
            .padding()
            
            Text("Получатель платежа:")
                .modifier(RoundedTextLarge())
                .padding()
            Text(dataModel.fio)
                .modifier(RoundedTextMedium())
                .padding()
            Text(dataModel.fioEng)
                .modifier(RoundedTextMedium())
                .padding()
            
        }.onAppear {
            DataBaseServices.shared.getInfo { result in
                switch result {
                case .success(let data):
                    self.dataModel = data
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
}

//struct HowToPayView_Previews: PreviewProvider {
//    static var previews: some View {
//        HowToPayView(dataModel: InfoModel(email: "kiurushkin@gmail.com", phone: "+79110732191", telegram: "", howToPay: "", about: "", instagram: "", fio: "Юрушкин К.A"))
//    }
//}
