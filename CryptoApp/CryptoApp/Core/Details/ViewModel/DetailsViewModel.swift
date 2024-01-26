//
//  DetailsViewModel.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 06/01/24.
//

import Foundation
import SwiftUI
import Combine

class DetailsViewModel: ObservableObject {
    
    @Published var overviewDetails: [StatisticsModel] = []
    @Published var additionalDetails: [StatisticsModel] = []
    @Published var coin: CoinModel
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    let detailsDataService: CoinDetailsDataService
    var cancallabels = Set<AnyCancellable>()

    
    init(coin: CoinModel) {
        self.coin = coin
        self.detailsDataService = CoinDetailsDataService(coin: coin)
        self.detailsSubscribing()
    }
    
    
    func detailsSubscribing () {
        detailsDataService.$details
            .combineLatest($coin)
            .map(detailsMap)
            .sink(receiveValue: { [weak self] details in
                self?.overviewDetails = details.overview
                self?.additionalDetails = details.additional
            })
            .store(in: &cancallabels)
        
        detailsDataService.$details
            .sink { [weak self] coinDetails in
                self?.coinDescription = coinDetails?.description?.en
                self?.redditURL = coinDetails?.links?.subredditURL
                self?.websiteURL = coinDetails?.links?.homepage?.first
            }
            .store(in: &cancallabels)
        
    }
    
    
    private func detailsMap(data: (DetailsModel?, CoinModel)) -> (overview: [StatisticsModel], additional: [StatisticsModel]) {
        let overview: [StatisticsModel] = [
            StatisticsModel(
                name: "Current Price",
                value: data.1.currentPrice.asCurrency(),
                percentageChange: data.1.priceChangePercentage24H
            ),
            StatisticsModel(
                name: "Market Capitalization",
                value: "$" + (data.1.marketCap?.formattedWithAbbreviations() ?? ""),
                percentageChange: data.1.marketCapChangePercentage24H
            ),
            StatisticsModel(name: "Rank", value: String(data.1.rank)),
            StatisticsModel(name: "Volume", value: "$" + (data.1.totalVolume?.formattedWithAbbreviations() ?? "")),
        ]
        
        let additional: [StatisticsModel] = [ 
            StatisticsModel(name: "High 24h", value: data.1.high24H?.asCurrency() ?? "n/a"),
            StatisticsModel(name: "Low 24h", value: data.1.low24H?.asCurrency() ?? "n/a"),
            StatisticsModel(name: "Price Change 24h",
                            value: data.1.priceChange24H?.asCurrency() ?? "n/a",
                            percentageChange: data.1.priceChangePercentage24H),
            StatisticsModel(name: "Market Cap change 24h",
                            value: String(data.1.marketCapChange24H ?? 0),
                            percentageChange: data.1.marketCapChangePercentage24H ?? 0),
            StatisticsModel(name: "Block Time",
                            value: data.0?.blockTimeInMinutes ?? 0 == 0 ? "n/a" : String(data.0?.blockTimeInMinutes ?? 0)),
            StatisticsModel(name: "Hashing Algorithm", value: data.0?.hashingAlgorithm ?? "n/a")
            
        
        ]
        
        return (overview, additional)
    }
    
}

