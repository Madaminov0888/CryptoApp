//
//  HomeStatsView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 27/10/23.
//

import SwiftUI

struct HomeStatsView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showProfile: Bool
    
    var body: some View {
        HStack {
            ForEach(vm.stats) { stat in
                StatisticsView(statistics: stat)
                    .frame(width: UIScreen.main.bounds.width / 3)
            }
        }
        .frame(width: UIScreen.main.bounds.width, alignment: showProfile ? .trailing : .leading)
    }
}

#Preview {
    HomeStatsView(showProfile: .constant(false))
        .environmentObject(Preview.dev.homeVM)
}
