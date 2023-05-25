//
//  PrivacyView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 18.05.2023.
//

import Foundation
import SwiftUI


struct PrivacyView : View {
    
  @State  var dataModel : InfoModel
    
    var body: some View {
        VStack {
            Capsule()
                .frame(width: 40, height: 7)
                .foregroundColor(.gray)
                .padding()
            ScrollView {
                Text("Политика концидициальности")
                    .modifier(RoundedTextLarge())
                Text(dataModel.privacy)
                .modifier(RoundedTextMedium())
            }
            .padding()
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
