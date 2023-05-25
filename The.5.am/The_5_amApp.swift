//
//  The_5_amApp.swift
//  The.5.am
//
//  Created by Кирилл Юрушкин on 29.03.2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

let screen = UIScreen.main.bounds


@main
struct The_5_amApp: App {
    @StateObject private var dataController = CartViewModel()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
