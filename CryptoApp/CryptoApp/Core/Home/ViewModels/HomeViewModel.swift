//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 09/10/23.
//

import Foundation
import SwiftUI
import Combine



class HomeViewModel: ObservableObject {
    @Published var coins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var stats: [StatisticsModel] = []
    @Published var sortingOp: SortingOptions = .rank
    
    var cancallables = Set<AnyCancellable>()
    private let coinDataService = CoinsDataService()
    private let marketDataService = MarketDataService()
    private let profileDataService = ProfileDataService()
    
    
    enum SortingOptions {
        case rank, rankReversed, holding, holdingReversed, price, priceReversed
    }
    
    
    
    init() {
        getSubscription()
    }
    
    
    //MARK: Publishers and subscribing
    
    func getSubscription() {
//        dataService.$allCoins
//            .sink { [weak self] coins2 in
//                self?.coins = coins2
//            }
//            .store(in: &cancallables)
        
        $searchText
            .combineLatest( coinDataService.$allCoins, $sortingOp)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(mapCoinDataModel)
            .sink { [weak self] filteredCoins in
                self?.coins = filteredCoins
            }
            .store(in: &cancallables )
        
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapMarketStats)
            .sink { [weak self] returnedStats in
                self?.stats = returnedStats
            }
            .store(in: &cancallables)
        
        
        $coins
            .combineLatest(profileDataService.$entities)
            .map(profileCoinsAdd)
            .sink { [weak self] profileCoins in
                self?.portfolioCoins = profileCoins
            }
            .store(in: &cancallables)
        
    }
    
    
    //MARK: Portfolio coins func
    
    private func profileCoinsAdd(allCoins: Published<[CoinModel]>.Publisher.Output, entities: Published<[ProfileEntity]>.Publisher.Output) -> [CoinModel] {
        var profileCoins: [CoinModel] = []
        
        for i in entities {
            for j in allCoins {
                if i.coinID == j.id {
                    profileCoins.append(j.updateHoldings(amount: i.amount))
                    break
                }
            }
        }
        
        
        switch sortingOp {
        case .holding:
            return profileCoins.sorted(by: { $0.currentHoldings ?? 0 < $1.currentHoldings ?? 0 })
        case .holdingReversed:
            return profileCoins.sorted(by: { $0.currentHoldings ?? 0 > $1.currentHoldings ?? 0 })
        case .rank:
            return profileCoins
        case .rankReversed:
            return profileCoins.sorted(by: { $0.rank > $1.rank })
        case .price:
            return profileCoins.sorted(by: { $0.currentPrice < $1.currentPrice })
        case .priceReversed:
            return profileCoins.sorted(by: { $0.currentPrice < $1.currentPrice }).reversed()
        }
        
        
//        return profileCoins
    }
    
    
    func reloadData() {
        coinDataService.getCoins()
        marketDataService.getCoins()
    }
    
    
    func updateProfile(coin: CoinModel, amount: Double) {
        profileDataService.updateProfile(coin: coin, amount: amount)
    }
    
    
    // MARK: MARKET stats func
    
    private func mapMarketStats(marketData: MarketDataModel?, portfoilioCoins: [CoinModel]) -> [StatisticsModel] {
        var stats: [StatisticsModel] = []
        
        guard let data = marketData else {
            return stats
        }
        
        let marketCap = StatisticsModel(name: "Market Cap", value: data.data.marketCap, percentageChange: data.data.marketCapChangePercentage24HUsd)
        let volume = StatisticsModel(name: "24h volume", value: data.data.volume)
        let btcDominance = StatisticsModel(name: "BTC Dominance", value: data.data.btcDominance)
        
        
        let portfolio24hBefore = portfoilioCoins.map({ ($0.currentPrice - ($0.priceChange24H ?? 0.0)) * ($0.currentHoldings ?? 0.0) }).reduce(0.0, +)
        let portfolio24hChanges = portfoilioCoins.map({ ($0.priceChange24H ?? 0) * ($0.currentHoldings ?? 0) }).reduce(0.0, +)
        let percent: Double = (portfolio24hChanges * 100) / portfolio24hBefore
        
        let profile = StatisticsModel(name: "Profile", value: allCoinsHoldings(coins: portfoilioCoins), percentageChange: percent)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            profile,
        ])
        
        return stats
    }
    
    
    
    
    private func allCoinsHoldings(coins: [CoinModel]) -> String {
        var allHoldings: Double = 0
        for i in coins {
            allHoldings += i.currentHoldingsValue
        }
        return allHoldings.asCurrency2()
    }
    
    
    // MARK: ALL coins map func
    
    private func mapCoinDataModel(text: String, coins: [CoinModel], sortingOp: SortingOptions) -> [CoinModel] {
        guard !text.isEmpty else {
            switch sortingOp {
            case .holding:
                return coins.sorted(by: { $0.currentHoldings ?? 0 < $1.currentHoldings ?? 0 })
            case .holdingReversed:
                return coins.sorted(by: { $0.currentHoldings ?? 0 > $1.currentHoldings ?? 0 })
            case .rank:
                return coins
            case .rankReversed:
                return coins.sorted(by: { $0.rank > $1.rank })
            case .price:
                return coins.sorted(by: { $0.currentPrice < $1.currentPrice })
            case .priceReversed:
                return coins.sorted(by: { $0.currentPrice < $1.currentPrice }).reversed()
            }
        }
        var filteredCoins: [CoinModel] = []
        
        for i in coins {
            if i.name.lowercased().contains(text.lowercased()) || i.symbol.lowercased().contains(text.lowercased()) || i.id.lowercased().contains(text.lowercased()) {
                filteredCoins.append(i)
            }
        }
        var finalList: [CoinModel] = []
        if filteredCoins.isEmpty {
            finalList = coins
        } else {
            finalList = filteredCoins
        }
        
        switch sortingOp {
        case .holding:
            return finalList.sorted(by: { $0.currentHoldings ?? 0 < $1.currentHoldings ?? 0 })
        case .holdingReversed:
            return finalList.sorted(by: { $0.currentHoldings ?? 0 > $1.currentHoldings ?? 0 })
        case .rank:
            return finalList
        case .rankReversed:
            return finalList.reversed()
        case .price:
            return finalList.sorted(by: { $0.currentPrice < $1.currentPrice })
        case .priceReversed:
            return finalList.sorted(by: { $0.currentPrice < $1.currentPrice }).reversed()
        }
        
    }
}
