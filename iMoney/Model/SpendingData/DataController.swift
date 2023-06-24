//
//  DataController.swift
//  myMoney
//
//  Created by Никита on 14.01.2023.
//

import Foundation
import CoreData

final class DataController: ObservableObject {
    
    let container = NSPersistentContainer(name: "SM")
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                fatalError("Failed to load the data: \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("data saved")
        } catch {
            print("can't save the data")
        }
    }
    
    func addSpending(name: String, date: Date, amount: Int64, category: String, spendType: String, context: NSManagedObjectContext) {
        let spending = Spend(context: context)
        spending.category = category
        spending.id = UUID()
        spending.date = date
        spending.name = name
        spending.amount = amount
        spending.spendType = spendType
        
        save(context: context)
    }
    
}
