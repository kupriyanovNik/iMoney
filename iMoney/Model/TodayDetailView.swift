//
//  TodayDetailView.swift
//  iMoneyPet
//
//  Created by Никита on 22.01.2023.
//

import SwiftUI

/// not used
struct TodayDetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var spendings: FetchedResults<Spend>
    var body: some View {
        VStack {
            Text("Потрачено за сегодня: \(Int(totalMoneyToday()))₽")
                .font(.system(size: 20))
                .bold()
                .foregroundColor(.accentColor)
            Text("Трат сегодня: \(totalSpendingsToday())")
                .foregroundColor(.accentColor)
                .padding(.bottom, 30)
            Text("Всего потрачено: \(Int(totalMoney()))₽")
                .font(.system(size: 20))
                .foregroundColor(.accentColor)
                .bold()
            Text("Всего трат: \(totalSpendings())")
                .foregroundColor(.accentColor)
        }
    }
    private func totalMoneyToday() -> Int64 {
        var moneyToday: Int64 = 0
        for item in spendings {
            if let date = item.date {
                if Calendar.current.isDateInToday(date) {
                    moneyToday += item.amount
                }
            }
        }
        return moneyToday
    }
    private func totalMoney() -> Int64 {
        var money: Int64 = 0
        for item in spendings {
            money += item.amount
        }
        return money
    }
    private func totalSpendingsToday() -> Int {
        var total: Int = 0
        for item in spendings {
            if let date = item.date {
                if Calendar.current.isDateInToday(date) {
                    total += 1
                }
            }
        }
        return total
    }
    private func totalSpendings() -> Int {
        var total: Int = 0
        for _ in spendings {
            total += 1
        }
        return total
    }

}

struct TodayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TodayDetailView()
            .environmentObject(ViewModel())
    }
}
