//
//  AboutView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 17.04.2023.
//

import SwiftUI

struct AboutView: View {
    
    @State var dataModel : InfoModel
    
    var body: some View {
        VStack {
            HStack {
                Text("О нас")
                    .modifier(InfoText())
                    .padding()
            }
            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    Image("insta.logo")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                    Link("The.5.am", destination: URL(string: dataModel.instagram)!)
                    
                }
                .modifier(InfoText())

                HStack {
                    Image("telegram")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                    Link("Telegram", destination: URL(string: dataModel.telegram)!)
                    
                }
                .modifier(InfoText())
                
                HStack {
                    Image(systemName: "phone")
                    Text(dataModel.phone)
                        .modifier(RoundedTextMedium())
                }
                .modifier(InfoText())
                
                
                HStack {
                    Image(systemName: "envelope.fill")
                    Text(dataModel.email)
                        .modifier(RoundedTextMedium())
                }
                .modifier(InfoText())
                
                Text(dataModel.about)
                    .modifier(RoundedTextMedium())
                    .padding()
            }.padding()
            Spacer()
        }.onAppear {
            DataBaseServices.shared.getInfo { result in
                switch result {
                case .success(let infoData):
                    self.dataModel = infoData
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

//struct AboutView_Previews: PreviewProvider {
//    static var previews: some View {
//        AboutView(dataModel: InfoModel(email: "", phone: "", telegram: "", howToPay: "", about: "", instagram: "", fio: ""))
//    }
//}
