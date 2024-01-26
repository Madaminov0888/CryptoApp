//
//  StatisticsModel.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 27/10/23.
//

import Foundation


struct StatisticsModel: Identifiable {
    let id: String = UUID().uuidString
    let name: String
    let value: String
    let precentageChange: Double?
    
    init(name: String, value: String, percentageChange: Double? = nil) {
        self.name = name
        self.value = value
        self.precentageChange = percentageChange
    }
}
