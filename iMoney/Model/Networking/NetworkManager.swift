//
//  iMoneyPetApp.swift
//  iMoneyPet
//
//  Created by Никита on 14.01.2023.
//

import Foundation
import SwiftUI
import Combine


class DataService {
    @Published var coinExchange: Int = 80
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        let urlResource = Resources.API.self
        guard let url = URL(string: urlResource.mainURL.rawValue) else { return }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        request.addValue(urlResource.apiKEY.rawValue, forHTTPHeaderField: "apikey")
        coinSubscription = URLSession.shared.dataTaskPublisher(for: request)  //dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { (output) -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      response.statusCode >= 200 && response.statusCode < 300 else {
                    throw URLError(.badServerResponse)
                }
                return output.data
            }
            .receive(on: DispatchQueue.main)
            .decode(type: Welcome.self, decoder: JSONDecoder())
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("DEBUG: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] (returnedCoins) in
                self?.coinExchange = Int(returnedCoins.result)
                self?.coinSubscription?.cancel()
            }
    }
}
