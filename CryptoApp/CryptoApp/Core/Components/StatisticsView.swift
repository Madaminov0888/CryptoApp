//
//  StatisticsView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 27/10/23.
//

import SwiftUI

struct StatisticsView: View {
    
    let statistics: StatisticsModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(statistics.name)
                .font(.caption)
                .foregroundStyle(Color.csSecondaryTextColor)
            Text(statistics.value)
                .font(.headline)
                .foregroundStyle(Color.csAccent)
            
            
            HStack(spacing: 5) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (statistics.precentageChange ?? 0) >= 0 ? 0 : 180))
                
                Text((statistics.precentageChange?.asNumberForPercentage() ?? "") + "%")
                    .font(.caption)
                    .bold()
            }
            .foregroundStyle((statistics.precentageChange ?? 0) >= 0 ? Color.csGreen : Color.csRed)
            .opacity(statistics.precentageChange == nil ? 0 : 1)
        }
    }
}

#Preview {
    StatisticsView(statistics: Preview.dev.statistics1)
}
