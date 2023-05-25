//
//  ProfileView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 31.03.2023.
//

import SwiftUI
import iPhoneNumberField

struct ProfileView: View {
    
    @StateObject var viewModel : ProfileViewModel
    @Environment(\.colorScheme) var colorScheme
    
    @State var email : String = ""
    @State var password : String = ""
    @State var repiatPass : String = ""
    @State var name = ""
    @State var lastName = ""
    @State var phone = ""
    @State var adress = ""
    @State var isAuthView = false
    @State var isShowAlert = false
    @State var detailOrderView = false
    @State var isProfileView = false
    @State var privacyView = false
    @State var howToPayView = false
    @State var alertMassage = ""
    
    var body: some View {
        ZStack {
            if viewModel.profile.isAdmin {
                VStack {
                    AdminPanel(profileViewModel: viewModel)
                }
            } else {
                if viewModel.isProfileView {
                    ScrollView(.vertical) {
                        HStack {
                            Text("Профиль")
                                .modifier(RoundedTextLarge())
                            Spacer()
                            Button {
                                self.howToPayView.toggle()
                            } label: {
                                Text("Способы \n оплаты")
                                    .modifier(RoundedTextSmall())
                                    .foregroundColor(Color("5amBlue"))
                                    .padding()
                            }

                            Button {
                                AuthService.shared.signOut()
                                viewModel.isProfileView.toggle()
                            } label: {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 25)
                                    .foregroundColor(Color("5amBlue"))
                            }
                        }.padding(.horizontal, 20)

                                TextField("Имя", text: $viewModel.profile.name)
                                    .textFieldStyle(ProfileFixtFieldStule())
                                TextField("Фамилия", text: $viewModel.profile.lastName)
                                    .textFieldStyle(ProfileFixtFieldStule())
                                HStack {
                                    Image(systemName: "phone")
                                    TextField("Телефон", text: $viewModel.profile.phone)
                                        .keyboardType(.numberPad)
                                        .modifier(RoundedTextMedium())
                                }.padding(.vertical)
                                    .padding(.horizontal, 20)
                                    .background(colorScheme == .light ? Color(UIColor.systemGray6) : Color(UIColor.systemGray4))
                                    .clipShape(Capsule(style: .continuous))
                                    .opacity(0.9)
                                
                                TextField("Город, улица, дом, индекс", text: $viewModel.profile.adress)
                                    .textFieldStyle(ProfileFixtFieldStule())


                            if viewModel.orders.count == 0 && viewModel.customOrders.count == 0 {
                                Text("Ваши заказы будут тут")
                            } else {
                                if viewModel.orders.count != 0 {
                                        Text("Заказы")
                                            .modifier(RoundedTextLarge())
                                        ForEach(viewModel.orders, id: \.id) { order in
                                            OrderCell(order: order)
                                                .onTapGesture {
                                                    viewModel.currentOrder = order
                                                    detailOrderView.toggle()
                                                }
                                        }
                                    }
                                    if viewModel.customOrders.count != 0 {
                                        Text("Индивидуальные заказы")
                                            .modifier(RoundedTextLarge())
                                        ForEach(viewModel.customOrders, id: \.id) { order in
                                            OrderCell(order: order)
                                                .padding(.vertical, 5)
                                                .onTapGesture {
                                                    viewModel.currentOrder = order
                                                    detailOrderView.toggle()
                                                }
                                    }
                                }
                            }
                    }
                    .onSubmit {
                        viewModel.setProfile()
                    }
                    .onAppear {
                        viewModel.getProfile()
                        viewModel.getOrders(custom: false)
                        viewModel.getOrders(custom: true)
                    }
                    .padding()
                    .sheet(isPresented: $detailOrderView) {
                        let orderViewModel = OrderViewModel(order: viewModel.currentOrder)
                        let profileViewModel = ProfileViewModel(profile: viewModel.profile)
                        OrderView(viewModel: orderViewModel, profileViewModel: profileViewModel)
                    }
                    .sheet(isPresented: $howToPayView) {
                        HowToPayView(dataModel: InfoModel(email: "", phone: "", telegram: "https://", howToPay: "", about: "", instagram: "https://", fio: "", iban: "", fioEng: "", privacy: ""))
                    }
                } else {
                    VStack {
                        Spacer()
                        if !isAuthView {
                            TextField("Введите ваше имя", text: $name)
                                .textFieldStyle(ProfileFixtFieldStule())
                            TextField("Введите вашу фамилию", text: $lastName)
                                .textFieldStyle(ProfileFixtFieldStule())
                            TextField("Введите ваш адрес", text: $adress)
                                .textFieldStyle(ProfileFixtFieldStule())
                        }
                        TextField("Введите email", text: $email)
                            .textFieldStyle(ProfileFixtFieldStule())
                            .keyboardType(.emailAddress)
                        SecureField("Ввежите пароль", text: $password)
                            .textFieldStyle(ProfileFixtFieldStule())
                        if !isAuthView {
                            SecureField("Повторите пароль", text: $repiatPass)
                                .textFieldStyle(ProfileFixtFieldStule())
                            
                            Text("Регистрируясь вы согласны с \(Text("пользовательским соглашением").foregroundColor(Color("5amBlue"))) и на обработку персональных данных.")
                                .modifier(RoundedTextSmall())
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .onTapGesture {
                                    privacyView.toggle()
                                }
                            
                            
                            Button {
                                if password == repiatPass {
                                    AuthService.shared.createNewUser(email: self.email, password: self.password, phone: self.phone, adress: self.adress, name: self.name, lastName: self.lastName) { result in
                                        switch result {
                                        case .success(let user):
                                            self.alertMassage = "Вы зарегистрировались с email \(user.email!)"
                                            self.isShowAlert.toggle()
                                            self.email = ""
                                            self.password = ""
                                            self.repiatPass = ""
                                            self.viewModel.isProfileView.toggle()
                                            
                                        case .failure(let error):
                                            self.alertMassage = "Ошибка: \(error.localizedDescription)"
                                            self.isShowAlert.toggle()
                                        }
                                    }
                                } else {
                                    alertMassage = "Введенные пароли не совпадают"
                                    repiatPass = ""
                                    isShowAlert.toggle()
                                }
                            } label: {
                                Text("Регистрация")
                                    .modifier(ProfileButtonStyle())
                            }
                        } else {
                            Button {
                                AuthService.shared.signIn(email: email, password: password) { result in
                                    switch result {
                                    case .success(_):
                                        self.email = ""
                                        self.password = ""
                                        self.viewModel.isProfileView.toggle()
                                    case .failure(let error):
                                        alertMassage = "Ошибка \(error.localizedDescription)"
                                        isShowAlert.toggle()
                                    }
                                }
                            } label: {
                                Text("Войти")
                                    .padding(.horizontal)
                                    .modifier(ProfileButtonStyle())
                            }
                            Spacer()
                            NavigationLink {
                                ResetPasswordView()
                            } label: {
                                Text("Забыли пароль?")
                                    .modifier(RoundedTextMedium())
                                    .foregroundColor(Color("5amBlue"))
                                    .padding()
                            }
                        }
                        ZStack {
                            Capsule()
                                .strokeBorder(lineWidth: 2)
                                .frame(width: 300, height: 50)
                            HStack {
                                Text(!isAuthView ? "Уже есть аккаунт?" : "Eще не с нами?")
                                    .foregroundColor(.gray)
                                    .modifier(RoundedTextMedium())
                                Text(!isAuthView ? "Вход" : "Регистрация")
                                    .modifier(RoundedTextMedium())
                            }
                            .onTapGesture {
                                isAuthView.toggle()
                            }
                        }
                       
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 70)
                    .animation(.easeInOut(duration: 0.5), value: isAuthView)
                    .alert(Text(alertMassage), isPresented: $isShowAlert) {
                        Text("Ok")
                    }
                    .sheet(isPresented: $privacyView) {
                        PrivacyView(dataModel: InfoModel(email: "", phone: "", telegram: "https://", howToPay: "", about: "", instagram: "https://", fio: "", iban: "", fioEng: "", privacy: ""))
                    }
                }
            }
        }
    }
}








//
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(viewModel: ProfileViewModel(profile: MWUser(id: UUID().uuidString, name: "Кирилл", lastName: "Юрушкин", adress: "Россия, Калининградская область, г.Калининград, ул.Споривная 8, 236010", phone: "9110732191", email: "iuruskin@mail.ru")))
//    }
//}
//



