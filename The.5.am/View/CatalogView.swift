//
//  CatalogView.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 30.03.2023.
//

import SwiftUI

struct CatalogView: View {
   
    @Environment(\.colorScheme) var colorScheme
    @StateObject var viewModel = CatalogViewModel()
    @State var infoView = false
    var grid : [GridItem] = [GridItem(.fixed(screen.width * 0.45), spacing: 10, alignment: .center)]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    Spacer()
                        .frame(width: 30)
                        .padding()
                    Image("logo 5am ios")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200)
                        .shadow(radius: 5)
                    Button {
                        infoView.toggle()
                    } label: {
                        ZStack {
                            Image(systemName: "info.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30)
                                .padding()
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                        }
                    }
                }
                Spacer()
            }
            Section {
                Text(TypeEnum.hanger.rawValue)
                    .font(.system(.title, design: .rounded, weight: .regular))
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: grid, alignment: .center, spacing: 15) {
                        ForEach(viewModel.hangers, id: \.id) { hanger in
                            NavigationLink {
                                let viewModel = ProductDetailViewModel(product: hanger)
                                ProductDetailView(viewModel: viewModel)
                            } label: {
                                ProductCell(product: hanger, viewModel: ProductDetailViewModel(product: hanger), photos: Photos())
                                    .foregroundColor(.black)
                            }

                        }
                    }
                .padding()
                }
            }
            Section {
                Text(TypeEnum.chainring.rawValue)
                    .font(.system(.title, design: .rounded, weight: .regular))
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: grid, alignment: .center, spacing: 15) {
                        ForEach(viewModel.chainrings, id: \.id) { chainring in
                            NavigationLink {
                                let viewModel = ProductDetailViewModel(product: chainring)
                                ProductDetailView(viewModel: viewModel)
                            } label: {
                                ProductCell(product: chainring, viewModel: ProductDetailViewModel(product: chainring), photos: Photos())
                                    .foregroundColor(.black)
                            }

                        }
                    }
                .padding()
                }
            }
            Section {
                Text(TypeEnum.tool.rawValue)
                    .font(.system(.title, design: .rounded, weight: .regular))
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: grid, alignment: .center, spacing: 15) {
                        ForEach(viewModel.tools, id: \.id) { tools in
                            NavigationLink {
                                let viewModel = ProductDetailViewModel(product: tools)
                                ProductDetailView(viewModel: viewModel)
                            } label: {
                                ProductCell(product: tools, viewModel: ProductDetailViewModel(product: tools), photos: Photos())
                                    .foregroundColor(.black)
                            }

                        }
                    }
                .padding()
                }
            }
            Section {
                Text(TypeEnum.other.rawValue)
                    .font(.system(.title, design: .rounded, weight: .regular))
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: grid, alignment: .center, spacing: 15) {
                        ForEach(viewModel.other, id: \.id) { other in
                            NavigationLink {
                                let viewModel = ProductDetailViewModel(product: other)
                                ProductDetailView(viewModel: viewModel)
                            } label: {
                                ProductCell(product: other, viewModel: ProductDetailViewModel(product: other), photos: Photos() )
                                    .foregroundColor(.black)
                            }

                        }
                    }
                .padding()
                }
            }
            Section {
                Text(TypeEnum.light.rawValue)
                    .font(.system(.title, design: .rounded, weight: .regular))
                ScrollView(.horizontal, showsIndicators: true) {
                    LazyHGrid(rows: grid, alignment: .center, spacing: 15) {
                        ForEach(viewModel.light, id: \.id) { light in
                            NavigationLink {
                                let viewModel = ProductDetailViewModel(product: light)
                                ProductDetailView(viewModel: viewModel)
                            } label: {
                                ProductCell(product: light, viewModel: ProductDetailViewModel(product: light), photos: Photos())
                                    .foregroundColor(.black)
                            }

                        }
                    }
                .padding()
                }
            }
            .sheet(isPresented: $infoView) {
                AboutView(dataModel: InfoModel(email: "", phone: "", telegram: "https://", howToPay: "", about: "", instagram: "https://", fio: "", iban: "", fioEng: "", privacy: ""))
            }
        }.onAppear {
            self.viewModel.getProductsBySort()
        }
        
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView()
    }
}
