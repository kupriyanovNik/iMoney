//
//  SpendCell.swift
//  iMoneyPet
//
//  Created by Никита on 22.01.2023.
//

import SwiftUI

struct SpendCell: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: ViewModel
    var spend: Spend
    var showCategory: Bool
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(spend.name ?? "")
                    .bold()
                Text("\(Int(spend.amount)) ₽")
            }
            .contextMenu {
                Text(((spend.date ?? Date()).formatted()))
                Text("\(String(format: "%.2f", Double(spend.amount) / Double(viewModel.currentExchangeRate))) EUR")
                Text(LocalizedStringKey(spend.spendType ?? ""))
            }
            Spacer()
            Text(LocalizedStringKey(spend.category ?? ""))
                .foregroundColor((colorScheme == .dark ? Color.mint : Color.orange).opacity(showCategory ? 0.5 : 0.1))
            
        }
        
    }
}
