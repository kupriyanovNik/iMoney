//
//  CustomListRows.swift
//  myMoney
//
//  Created by Никита on 18.08.2022.
//

import SwiftUI

struct CustomListRows: View {
    @Environment(\.colorScheme) var colorScheme
    var text: String = "Расходы на здоровье"
    var countOfOperations: Int = 0
    var countMoneyOfSpending: Int = 0
    var body: some View {
        ZStack {
            Color(colorScheme == .dark ? .gray : .systemTeal)
                .cornerRadius(20)
            VStack(spacing: 30) {
                Text("\(text): \(countOfOperations)")
                    .font(.system(size: 20, weight: .bold))
                    .allowsTightening(true)
                Text("\(countMoneyOfSpending)₽")
                    .font(.system(size: 35, weight: .semibold, design: .default))
                    .allowsTightening(true)
            }
            .padding(20)
        }
        .ignoresSafeArea()
        .frame(width: 300, height: 150, alignment: .leading)
    }
}

struct CustomListRows_Previews: PreviewProvider {
    static var previews: some View {
        CustomListRows()
    }
}
