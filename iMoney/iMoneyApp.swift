//
//  iMoneyApp.swift
//  iMoney
//
//  Created by Никита Куприянов on 12.06.2023.
//

import SwiftUI
import Combine

@main
struct iMoneyPetApp: App {
    @StateObject private var viewModel = ViewModel()
    @StateObject private var dataController = DataController()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
