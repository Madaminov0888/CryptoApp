//
//  XMarkButton.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 30/10/23.
//

import SwiftUI

struct XMarkButton: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button(action: {
            dismiss.callAsFunction()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        })
    }
}

#Preview {
    XMarkButton()
}
