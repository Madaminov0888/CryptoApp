//
//  HomeView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 25/09/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var vm: HomeViewModel
    @State private var showProfile: Bool = false
    @State var searchText: String = ""
    @State private var showProfileSheetView: Bool = false
    
    //detail view variables
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    
    // MARK: MAIN BODY
    var body: some View {
        ZStack {
            //background
            Color.csBackgroundColor
                .ignoresSafeArea()
                .sheet(isPresented: $showProfileSheetView, content: {
                    ProfileView()
                        .environmentObject(vm)
                })
            
            //content
            VStack {
                headerView()
                .padding(.horizontal)
                
                HomeStatsView(showProfile: $showProfile)
                
                SearchBarView(searchText: $vm.searchText)
                
                CoinsHeader()
                
                if !showProfile {
                    AllCoinView()
                        .transition(.move(edge: .leading))
                } else {
                    PortfolioCoinView()
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
        }
        .navigationDestination(isPresented: $showDetailView) { DetailLoadingView(coin: $selectedCoin) }
    }
    
    
    // MARK: Header Views
    @ViewBuilder func headerView() -> some View {
        HStack {
            CircleButtonView(iconName: showProfile ? "plus" : "info")
                .animation(.none, value: showProfile)
                .onTapGesture {
                    if showProfile {
                        showProfileSheetView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animateButton: $showProfile)
                )
            
            Spacer()
            
            Text(showProfile ? "Profile" : "Live prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundStyle(Color.csAccent)
                .animation(.none, value: showProfile)
            
            
            Spacer()
            
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(showProfile ? Angle(degrees: 180) : .zero)
                .onTapGesture {
                    withAnimation(.spring) {
                        showProfile.toggle()
                    }
                }
        }
    }
    
    // MARK: ALLCoins View
    @ViewBuilder func AllCoinView() -> some View {
        List {
            ForEach(vm.coins) { coin in
                CoinRowView(coin: coin, showHoldings: showProfile)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        navigationLinkFunc(coin: coin)
                    }
            }
        }
        .refreshable {
            HapticManager.instance.notification(type: .success)
            vm.reloadData()
        }
        .listStyle(PlainListStyle())
    }
    
    // MARK: Portfoilio coins VIew
    @ViewBuilder func PortfolioCoinView() -> some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldings: showProfile)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        navigationLinkFunc(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    // MARK: Coins Header View
    @ViewBuilder func CoinsHeader() -> some View {
        HStack {
            HStack(spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.accentColor)
                    .opacity(vm.sortingOp == .rank || vm.sortingOp == .rankReversed ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortingOp == .rank ? 0 : 180))
            }
                .onTapGesture {
                    withAnimation(.default) {
                        vm.sortingOp = vm.sortingOp == .rank ? .rankReversed : .rank
                    }
                }
            Spacer()
            
            if showProfile {
                HStack(spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .foregroundStyle(Color.accentColor)
                        .opacity(vm.sortingOp == .holding || vm.sortingOp == .holdingReversed ? 1 : 0)
                        .rotationEffect(Angle(degrees: vm.sortingOp == .holding ? 0 : 180))
                }
                    .onTapGesture {
                        withAnimation {
                            vm.sortingOp = vm.sortingOp == .holding ? .holdingReversed : .holding
                        }
                    }
            }
            
            HStack(spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .foregroundStyle(Color.accentColor)
                    .opacity(vm.sortingOp == .price || vm.sortingOp == .priceReversed ? 1 : 0)
                    .rotationEffect(Angle(degrees: vm.sortingOp == .price ? 0 : 180))
            }
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                .onTapGesture {
                    withAnimation {
                        vm.sortingOp = vm.sortingOp == .price ? .priceReversed : .price
                    }
                }
        }
        .font(.caption)
        .foregroundStyle(Color.csSecondaryTextColor)
        .padding(.horizontal)
    }
}


extension HomeView {
    private func navigationLinkFunc(coin: CoinModel) {
        selectedCoin = coin
        showDetailView.toggle()
    }
}


#Preview {
    NavigationStack {
        HomeView()
            .toolbar(.hidden)
    }
    .environmentObject(Preview.dev.homeVM)
}

