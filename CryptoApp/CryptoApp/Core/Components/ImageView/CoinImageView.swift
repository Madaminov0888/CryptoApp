//
//  CoinImageView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 22/10/23.
//

import SwiftUI

struct CoinImageView: View {
    let coin: CoinModel
    @StateObject var vm: ImagesViewModel
    
    init(coin: CoinModel) {
        self.coin = coin
        _vm =  StateObject(wrappedValue: ImagesViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark")
                    .foregroundStyle(Color.csSecondaryTextColor)
            }
        }
    }
}

#Preview {
    CoinImageView(coin: Preview.dev.coin)
        .padding()
}
