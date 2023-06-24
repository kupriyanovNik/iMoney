//
//  ViewWithTabBar.swift
//  myMoney
//
//  Created by Никита on 10.08.2022.
//

import SwiftUI

struct ViewWithTabBar: View {
    
    @EnvironmentObject var model: ViewModel

    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var spendings: FetchedResults<Spend>
    @Environment(\.colorScheme) var colorScheme
    @State var bottomState: CGSize = .zero
    var body: some View {
        ZStack {
            TabView {
                WelcomeView()
                    .tabItem {
                        Label("Добавить", systemImage: "rublesign.circle")
                    }
                MainView()
                    .tabItem {
                        Label("Траты", systemImage: "books.vertical")
                    }
                    .badge(model.showingNew)
                if isSomeMoenySpended() {
                    DetailView()
                        .tabItem {
                            Label("Контроль", systemImage: "lasso.and.sparkles")
                        }
                    
                }
            }
            .tabViewStyle(.automatic)
            .accentColor(colorScheme == .dark ? Color.white.opacity(0.7) : Color.red.opacity(0.6))
            VStack {
                Spacer()
                if model.showingAlert {
                    AmountDetailView()
                        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom)))
                        .offset(y: bottomState.height)
                        .animation(.easeInOut, value: model.showingAlert)
                        .ignoresSafeArea()
                        .offset(y: 650)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.bottomState = value.translation
                                }
                                .onEnded { value in
                                    if self.bottomState.height > 50 {
                                        withAnimation {
                                            self.bottomState = .zero
                                            self.model.showingAlert = false
                                        }
                                    } else {
                                        withAnimation {
                                            self.bottomState = .zero
                                        }
                                    }
                                }
                        )
                }
            }
            
            
        }
    }
    func isSomeMoenySpended() -> Bool {
        for item in spendings {
            if item.amount != 0 {
                return true
            }
        }
        return false
    }
}

struct ViewWithTabBar_Previews: PreviewProvider {
    static var previews: some View {
        ViewWithTabBar()
            .environmentObject(ViewModel())
    }
}


