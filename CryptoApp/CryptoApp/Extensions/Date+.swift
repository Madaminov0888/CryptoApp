//
//  Date+.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 10/01/24.
//

import SwiftUI
import Foundation


extension Date {
    
    //"2021-03-13T20:49:26.606Z"
    init(coinString: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let coinDate = formatter.date(from: coinString)
        self.init(timeInterval: 0, since: Date())
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortFormatter() -> String {
        return shortFormatter.string(from: self)
    }
    
}

