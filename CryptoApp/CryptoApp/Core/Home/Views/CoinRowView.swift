//
//  CoinRowView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 03/10/23.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldings: Bool
    
    var body: some View {
        HStack {
            coinNameView()
            
            Spacer()
            if showHoldings {
                holdingsView()
            }
            
            
            priceView()
        }
        .font(.subheadline)
        .background(
            Color.csBackgroundColor.opacity(0.001)
        )
    }
    
    @ViewBuilder func coinNameView() -> some View {
        Text(String(coin.rank))
            .font(.caption)
            .foregroundStyle(Color.csSecondaryTextColor)
            .frame(minWidth: 30)
        CoinImageView(coin: coin)
            .frame(width: 30)
        Text(coin.symbol.uppercased())
            .font(.headline)
            .padding(.leading, 4)
            .foregroundStyle(Color.csAccent)
    }
    
     
    @ViewBuilder func holdingsView() -> some View {
        VStack(alignment: .trailing) {
            Text((coin.currentHoldingsValue).asCurrency2())
                .bold()
            Text(coin.currentHoldings?.asNumberForPercentage() ?? "")
                .font(.subheadline)
        }
        .foregroundStyle(Color.csAccent)
    }
    
    
    @ViewBuilder func priceView() -> some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrency())
                .bold()
                .foregroundStyle(Color.csAccent)
            Text((coin.priceChangePercentage24H ?? 0).asNumberForPercentage()+"%")
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0) < 0 ?
                    Color.csRed :
                    Color.csGreen
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CoinRowView(coin: Preview.dev.coin, showHoldings: true)
    }
    .environmentObject(Preview.dev.homeVM)
}
