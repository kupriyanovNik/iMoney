//
//  FilterResults.swift
//  iMoneyPet
//
//  Created by Никита Куприянов on 11.06.2023.
//

import Foundation

enum FilteringType: String, CaseIterable, Equatable {
    case all
    case food
    case devices
    case entertainments
    case car
    case dwelling
    case animals
    case health
    case clothes
    case uncategorized
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}
