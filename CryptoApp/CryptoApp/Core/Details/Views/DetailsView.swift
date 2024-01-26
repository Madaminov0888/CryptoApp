//
//  DetailsView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 06/01/24.
// 

import SwiftUI


struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    var body: some View {
        ZStack {
            if let coin = coin {
                DetailsView(coin: coin)
            } 
        }
    }
}


struct DetailsView: View {
     
    @StateObject private var vm: DetailsViewModel
    private var columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    @State private var readMore: Bool = false
     

    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailsViewModel(coin: coin))
    }


    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ChartView(coin: vm.coin)
                    .frame(height: 150)
                    .padding(.vertical, 30)
                    .padding(.bottom, 10)
                
                
                DetailsTitle(title: "Overview")
                
                CoinDescriptionView()
                
                
                Divider()
                
                VGridsView(details: vm.overviewDetails)
                
                DetailsTitle(title: "Additional Details")
                
                Divider()
                
                VGridsView(details: vm.additionalDetails)
                
                HStack(spacing: 20) {
                    CoinWebsiteURL(stringURL: vm.websiteURL, title: "Website")
                        .padding(.leading, 5)
                    CoinWebsiteURL(stringURL: vm.redditURL, title: "SubReddit")
                    Spacer()
                }
                .tint(.blue)
                .frame(maxWidth: .infinity)
                
                
            }
            .padding()
        }
        .navigationTitle(vm.coin.name)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                coinToolbarContent()
            }
        })
        .toolbarTitleDisplayMode(.large)
    }
    
}

extension DetailsView {
    
    @ViewBuilder
    private func CoinWebsiteURL(stringURL: String?, title: String) -> some View {
        if let stringURL = stringURL,
           let url = URL(string: stringURL) {
            Link(title, destination: url)
        }
    }
    
    
    @ViewBuilder
    private func CoinDescriptionView() -> some View {
        if let description = vm.coinDescription, !description.isEmpty {
            VStack(alignment: .leading) {
                Text(description.removingHTMLOccurances)
                    .font(.callout)
                    .foregroundStyle(Color.csSecondaryTextColor)
                    .lineLimit(readMore ? nil : 3)
        
                Button(action: {
                    withAnimation(.easeInOut) {
                        readMore.toggle()
                    }
                }, label: {
                    HStack  {
                        Image(systemName: "chevron.down")
                            .rotationEffect(Angle(degrees: readMore ? 180 : 0))
                        Text(readMore ? "Show less" : "Read more")
                        Spacer()
                    }
                    .font(.headline)
                })
                .tint(.blue)
            }
        }
    }
    
    @ViewBuilder
    private func coinToolbarContent() -> some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.csSecondaryTextColor)
            CoinImageView(coin: vm.coin)
                .frame(width: 30)
        }
    }

    
    @ViewBuilder private func DetailsTitle(title: String) -> some View {
        Text(title)
            .foregroundStyle(Color.csAccent)
            .font(.title.bold())
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder private func VGridsView(details: [StatisticsModel]) -> some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading,
            spacing: 30,
            pinnedViews: [],
            content: {
                ForEach(details) { stat in
                    StatisticsView(statistics: stat)
                }
                
        })
    }
}



#Preview {
    NavigationStack {
        DetailsView(coin: Preview.dev.coin)
    }
}
