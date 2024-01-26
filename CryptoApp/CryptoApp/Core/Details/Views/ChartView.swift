//
//  ChartView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 10/01/24.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startDate: Date
    private let lastDate: Date
    @State private var perc: CGFloat = 0
    
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        self.maxY = coin.sparklineIn7D?.price?.max() ?? 0
        self.minY = coin.sparklineIn7D?.price?.min() ?? 0
        
        self.lineColor = ((data.last ?? 0) >= (data.first ?? 0) ? .csGreen : .csRed)
        
        self.lastDate = Date(coinString: coin.lastUpdated ?? "")
        self.startDate = lastDate.addingTimeInterval(-7*24*60*60)
        
    }
    
    var body: some View {
        VStack {
            ChartGraphView()
                .frame(height: 200)
                .background(ChartBackground())
                .overlay(alignment: .leading) { ChartOverlay() }
            
            HStack {
                Text(startDate.asShortFormatter())
                Spacer()
                Text(lastDate.asShortFormatter())
            }
        }
        .font(.caption)
        .foregroundStyle(Color.csSecondaryTextColor)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.linear(duration: 1.5)) {
                    perc = 1
                }
            }
        }
    }
}


#Preview {
    ChartView(coin: Preview.dev.coin)
}



extension ChartView {
    private func ChartGraphView() -> some View {
        GeometryReader { geometry in
            Path{ path in
                
                for i in data.indices {
                    let xPos = geometry.size.width / CGFloat(data.count) * CGFloat(i + 1)
                    let yAxis = maxY - minY
                    let yPos = (1 -  CGFloat((data[i] - minY) / yAxis)) * geometry.size.height
                    
                    if i == 0 {
                        path.move(to: .init(x: xPos, y: yPos))
                    }
                    
                    path.addLine(to: .init(x: xPos, y: yPos))
                    
                }
                
            }
            .trim(from: 0.0, to: perc)
            .stroke(lineColor ,style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor.opacity(0.9), radius: 10, x: 0.0, y: 10)
            .shadow(color: lineColor.opacity(0.3), radius: 10, x: 0.0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0.0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0.0, y: 40)
        }
    }
    
    
    private func ChartBackground() -> some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private func ChartOverlay() -> some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY)/2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
}

