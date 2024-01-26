//
//  CircleButtonAnimationView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 26/09/23.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    @Binding var animateButton: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5)
            .scale(animateButton ? 1.0 : 0)
            .opacity(animateButton ? 0 : 1)
            .animation(animateButton ? .easeInOut(duration: 0.22) : .none, value: animateButton)
    }
}

#Preview {
    CircleButtonAnimationView(animateButton: .constant(false))
        .foregroundStyle(Color.red)
}
