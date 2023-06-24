//
//  iMoneyPetApp.swift
//  iMoneyPet
//
//  Created by Никита on 14.01.2023.
//

import Foundation
import SwiftUI

enum Categories: String, CaseIterable, Equatable {
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
