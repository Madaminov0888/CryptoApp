//
//  ProfileView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 30/10/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var homeVM: HomeViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = ""
    @State private var showCheckMark: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0, content: {
                    SearchBarView(searchText: $homeVM.searchText)
                    
                    CoinsScrollView()
                    
                    SelectedCoinInfo()
                })
            }
            .navigationTitle("Edit Profile")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
                ToolbarItem {
                    saveButton()
                }
            })
            .onChange(of: homeVM.searchText) { oldValue, newValue in
                if newValue == "" {
                    unselectCoin()
                }
            }
        }
    }
    
    @ViewBuilder func SelectedCoinInfo() -> some View {
        if selectedCoin != nil {
            VStack(spacing: 20, content: {
                HStack {
                    Text("Current price of \(selectedCoin?.symbol.uppercased() ?? "")")
                    Spacer()
                    Text(String((selectedCoin?.currentPrice ?? 0).asCurrency()))
                }
                
                Divider()
                
                HStack {
                    Text("Amount holding")
                    Spacer()
                    TextField("Ex. 1.4", text: $quantityText)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                }
                
                Divider()
                
                HStack {
                    Text("Current Value")
                    Spacer()
                    Text(getCurrentValue().asCurrency2())
                }
            })
            .animation(nil)
            .padding()
            .font(.headline)
        }
    }
    
    
    @ViewBuilder func CoinsScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 10, content: {
                ForEach(homeVM.coins) { coin in
                    CoinLogoView(coin: coin)
                        .padding(.vertical, 5)
                        .frame(width: 75)
                        .onTapGesture {
                            withAnimation(.easeIn) {
                                selectCoinProfile(coin: coin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(coin.id == selectedCoin?.id ? Color.csGreen : Color.clear, lineWidth: 1.0)
                        )
                }
            })
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
}

extension ProfileView {
    private func selectCoinProfile(coin: CoinModel) {
        selectedCoin = coin
        
        if let slCoin = homeVM.portfolioCoins.first(where: { $0.id == coin.id }),
           let amount = slCoin.currentHoldings {
            quantityText = String(amount)
        } else {
            quantityText = ""
        }
    }
}



#Preview {
    ProfileView()
        .environmentObject(Preview.dev.homeVM)
}



extension ProfileView {
    private func getCurrentValue() -> Double {
        return (Double(self.quantityText) ?? 0.0) * (selectedCoin?.currentPrice ?? 0.0)
    }
    
    private func saveButton() -> some View {
        HStack(spacing: 0) {
            
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1 : 0)
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("SAVE")
            })
            .opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1 : 0)

        }
        .font(.headline)
    }
    
    private func saveButtonPressed() {
        guard 
            let coin = selectedCoin,
            let amount = Double(quantityText)
        else { return }
        
        homeVM.updateProfile(coin: coin, amount: amount)
        
        withAnimation(.easeIn) {
            showCheckMark = true
            
            unselectCoin()
        }
        
        UIApplication.shared.endEditing()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeOut) {
                showCheckMark = false
            }
        }
    }
    
    private func unselectCoin() {
        selectedCoin = nil
        homeVM.searchText = ""
    }
}
