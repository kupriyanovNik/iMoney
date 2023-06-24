//
//  MainViewIfNotSpended.swift
//  iMoneyPet
//
//  Created by Никита Куприянов on 11.06.2023.
//

import SwiftUI

struct MainViewIfNotSpended: View {
    @EnvironmentObject var viewModel: ViewModel
    var body: some View {
        NavigationView {
            Button {
                self.viewModel.showAddingView = true
            } label: {
                ZStack {
                    AnimatedGradient(colors: [.purple, .cyan])
                        .frame(width: 200, height: 75, alignment: .center)
                        .cornerRadius(15)
                        .overlay {
                            Text(LocalizedStringKey("mainText"))
                                .multilineTextAlignment(.center)
                                .bold()
                                .foregroundColor(.white)
                        }
                        .shadow(color: .purple.opacity(0.4), radius: 10, x: 0, y: 0)
                }
            }
            .buttonStyle(.plain)
            .navigationTitle(LocalizedStringKey("spendText"))
            .mainSheet(isPresented: $viewModel.showAddingView, viewToShow: AddingView(), model: viewModel)
        }
    }
}

struct MainViewIfNotSpended_Previews: PreviewProvider {
    static var previews: some View {
        MainViewIfNotSpended()
            .environmentObject(ViewModel())
    }
}
