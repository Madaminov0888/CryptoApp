//
//  CoinDetailsDataService.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 08/01/24.
//

import Foundation
import Combine


class CoinDetailsDataService {
    @Published var details: DetailsModel? = nil
    var coinSubscription: AnyCancellable?
    
    
    init(coin: CoinModel) {
        getCoinDetails(coin: coin)
    }
    
    func getCoinDetails(coin: CoinModel) {
        guard let urlMain = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false" ) else {
            print("Error with url")
            return
        }
        
        
        coinSubscription = NetworkManager.downloadData(url: urlMain)
            .decode(type: DetailsModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.sinkHandler, receiveValue: { [weak self] details in
                self?.details = details
                self?.coinSubscription?.cancel()
            })
    }
}
