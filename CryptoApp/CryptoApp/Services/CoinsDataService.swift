//
//  CoinsDataService.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 21/10/23.
//

import Foundation
import Combine


class CoinsDataService {
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        guard let urlMain = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else {
            print("Error with url")
            return
        }
        
        
        coinSubscription = NetworkManager.downloadData(url: urlMain)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.sinkHandler, receiveValue: { [weak self] allCoins in
                self?.allCoins = allCoins
                self?.coinSubscription?.cancel()
            })
    }
}
