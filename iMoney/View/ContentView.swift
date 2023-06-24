//
//  ContentView.swift
//  iMoneyPet
//
//  Created by Никита on 14.01.2023.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @Environment(\.requestReview) var requestReview
    
    @EnvironmentObject var viewModel: ViewModel
    
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var spendings: FetchedResults<Spend>
    @Environment(\.colorScheme) var colorScheme
    
    var filteredModel: [Spend] {
        switch viewModel.selectedFilterType {
        case .all:
            return spendings.filter { _ in true }
        default:
            return spendings.filter { $0.category! == viewModel.selectedFilterType.rawValue}
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if isSomeMoenySpended() {
                    mainViewIfSpended
                } 
            }
        }
        .mainSheet(isPresented: $viewModel.showAddingView, viewToShow: AddingView(), model: viewModel)
        
        
        
    }
    fileprivate func isSomeMoenySpended() -> Bool {
        return !spendings.isEmpty
    }
    private func deleteSpendings(offsets: IndexSet) {
        withAnimation {
            offsets.map { spendings[$0] }
            .forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
    private func totalExpenditureToday() -> Int {
        var moneyToday: Int64 = 0
        for item in spendings {
            if let date = item.date {
                if Calendar.current.isDateInToday(date) && item.spendType == "expenditure" {
                    moneyToday += item.amount
                }
            }
        }
        return Int(moneyToday)
    }
    
    private func totalAccumulationToday() -> Int {
        var moneyToday: Int64 = 0
        for item in spendings {
            if let date = item.date {
                if Calendar.current.isDateInToday(date) && item.spendType != "expenditure" {
                    moneyToday += item.amount
                }
            }
        }
        return Int(moneyToday)
    }
    
    private func totalMoney() -> Int64 {
        var money: Int64 = 0
        for item in spendings {
            money += item.amount
        }
        return money
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel())
    }
}

extension ContentView {
    private var mainViewIfSpended: some View {
        NavigationView {
            List {
                HStack {
                    HStack {
                        if viewModel.showExpenditure {
                            Text("\(totalExpenditureToday())₽ ").bold().foregroundColor(.red.opacity(0.7))
                            +
                            Text(LocalizedStringKey("today"))
                        } else {
                            Text("\(totalAccumulationToday())₽ ").bold().foregroundColor(.green.opacity(0.7))
                            +
                            Text(LocalizedStringKey("today"))
                        }
                    }
                    .onTapGesture {
                        withAnimation {
                            viewModel.showExpenditure.toggle()
                        }
                    }
                    .foregroundColor(.gray)
                    Spacer()
                    Picker("", selection: $viewModel.selectedFilterType) {
                        Text(LocalizedStringKey(FilteringType.all.rawValue))
                            .tag(FilteringType.all)
                        ForEach(FilteringType.allCases, id: \.rawValue) { type in
                            if spendings.filter({ $0.category == type.rawValue }).count != 0 && type != .all {
                                Text(LocalizedStringKey(type.rawValue))
                                    .tag(type)
                            }
                        }
                    }
                }
                ForEach(filteredModel, content: { spend in
                    if isSomeMoenySpended() {
                        SpendCell(spend: spend, showCategory: viewModel.selectedFilterType == .all)
                            .environmentObject(viewModel)
                    }
                })
                .onDelete(perform: deleteSpendings)
            }
            .onChange(of: spendings.count) { newValue in
                if newValue % 10 == 0 {
                    requestReview()
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        self.viewModel.showAddingView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle(LocalizedStringKey("spendText"))
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

extension View {
    func mainSheet(isPresented: Binding<Bool>, viewToShow: some View, model: ViewModel) -> some View {
        self.sheet(isPresented: isPresented) {
            viewToShow
                .environmentObject(model)
        }
    }
}
