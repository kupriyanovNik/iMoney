//
//  JSON.swift
//  iMoneyPet
//
//  Created by Никита Куприянов on 06.06.2023.
//

import Foundation


struct Welcome: Decodable {
    let date: String
    let info: Info
    let query: Query
    let result: Double
    let success: Bool
}

struct Info: Codable {
    let rate: Double
    let timestamp: Int
}

struct Query: Codable {
    let amount: Int
    let from: String
    let to: String
}
