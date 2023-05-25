//
//  ResetPasswordView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 21.05.2023.
//

import SwiftUI

struct ResetPasswordView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
    @State var email = ""
    @State var alertMassage = ""
    @State var alert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Сброс пароля")
                    .modifier(RoundedTextLarge())
                    .padding()
                
                TextField("Введите email", text: $email)
                    .keyboardType(.emailAddress)
                    .textFieldStyle(ProfileFixtFieldStule())
                    .padding()
                
                Button {
                    AuthService.shared.resetPassword(email: email) { result in
                        switch result {
                        case .success(let mail):
                            self.alertMassage = "Ссылка на сброс пароля отправлена на адрес \(mail)"
                            self.alert.toggle()
                        case .failure(let error):
                            self.alertMassage = "Ошибка: \(error.localizedDescription)"
                            self.alert.toggle()
                        }
                    }
                    
                    
                } label: {
                    Text("Сбросить пароль")
                        .modifier(ProfileButtonStyle())
                        .padding()
                }
                
            }.alert(alertMassage, isPresented: $alert) {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Text("Ok")
                }
            }
        }.navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "arrowshape.left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                    }
                }
            }
    }
}

struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}
