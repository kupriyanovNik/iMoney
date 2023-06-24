//
//  ViewModel.swift
//  iMoneyPet
//
//  Created by Никита on 14.01.2023.
//

import Foundation
import SwiftUI
import Combine
import CoreData

class ViewModel: ObservableObject {
    
    @Environment(\.managedObjectContext) var managedObjContext
    
    @Published var spendingName: String = ""
    @Published var spendingAmount: String = ""
    @Published var selectedCategory = Categories.uncategorized
    @Published var selectedDate = Date()
    @Published var spendType: SpendType = .expenditure
    
    @Published var showAddingView: Bool = false
    @Published var selectedTabItem: Int = 1
    
    @Published var currentExchangeRate = 80
    
    @Published var selectedFilterType: FilteringType = .all
    
    @Published var showExpenditure: Bool = true 
    
    private let dataService = DataService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        self.addSubscribers()
    }
    
    func addingButton(context: NSManagedObjectContext, action: @escaping () -> ()) {
        if self.spendingName != "", self.spendingAmount != "" {
            DataController().addSpending(
                name: String(self.spendingName),
                date: self.selectedDate,
                amount: (self.spendingAmount.count <= 15) ? Int64(self.spendingAmount)! : Int64(Int64.max - 1),
                category: self.selectedCategory.rawValue,
                spendType: spendType.rawValue,
                context: context
            )
            withAnimation {
                self.selectedFilterType = .all
                action()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.reset()
            }
        }
    }
    
    func reset() {
        self.spendingName = ""
        self.spendingAmount = ""
        self.selectedCategory = .uncategorized
        self.selectedDate = Date()
        self.spendType = .expenditure
    }
    func addSubscribers() {
        dataService.$coinExchange
            .sink { [weak self] returnedCoins in
                self?.currentExchangeRate = returnedCoins
            }
            .store(in: &cancellables)
        
    }
    
}


extension View {
    func hideKeyboard() {
        #if canImport(UIKit)
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}


