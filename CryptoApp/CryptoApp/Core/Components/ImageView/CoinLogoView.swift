//
//  CoinLogoView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 04/11/23.
//

import SwiftUI

struct CoinLogoView: View {
    
    let coin: CoinModel
    
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.csAccent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(coin.name)
                .font(.caption)
                .foregroundStyle(Color.csSecondaryTextColor)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center) 
        }
    }
}

#Preview {
    CoinLogoView(coin: Preview.dev.coin)
}
