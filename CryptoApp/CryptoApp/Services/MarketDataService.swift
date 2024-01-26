//
//  MarketDataService.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 30/10/23.
//

import Foundation
import Combine


class MarketDataService {
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let urlMain = URL(string: "https://api.coingecko.com/api/v3/global") else {
            print("Error with url")
            return
        }
        
        
        marketDataSubscription = NetworkManager.downloadData(url: urlMain)
            .decode(type: MarketDataModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.sinkHandler, receiveValue: { [weak self] marketDataReturned in
                self?.marketData = marketDataReturned
                self?.marketDataSubscription?.cancel()
            })
    }
}
