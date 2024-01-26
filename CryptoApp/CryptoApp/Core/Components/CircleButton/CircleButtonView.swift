//
//  CircleButtonView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 25/09/23.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
        Image(systemName: iconName)
            .font(.title)
            .foregroundColor(.csAccent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .fill(Color.csBackgroundColor)
            )
            .shadow(color: .csAccent.opacity(0.3), radius: 10)
            .padding()
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        CircleButtonView(iconName: "info")
            .colorScheme(.dark)
        
        CircleButtonView(iconName: "plus") 
            .colorScheme(.light)
    }
        
}
