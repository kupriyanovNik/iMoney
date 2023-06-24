//
//  MainView.swift
//  iMoneyPet
//
//  Created by Никита on 14.01.2023.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var spendings: FetchedResults<Spend>
    @State private var animateSymbol: Bool = false
    var body: some View {
        if isSomeMoenySpended() {
            TabView(selection: $viewModel.selectedTabItem) {
                ContentView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Label(LocalizedStringKey("main"), systemImage: "house")
                    }
                    .tag(1)
                DetailView()
                    .environmentObject(viewModel)
                    .tabItem {
                        Label(LocalizedStringKey("expenses"), systemImage: "chart.bar")
                    }
                    .tag(2)
            }
        } else {
            MainViewIfNotSpended()
                .environmentObject(viewModel)
        }
    }
}

extension MainView {
    fileprivate func isSomeMoenySpended() -> Bool {
        return !spendings.isEmpty
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(ViewModel())
    }
}
