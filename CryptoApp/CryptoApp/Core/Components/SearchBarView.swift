//
//  SearchBarView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 26/10/23.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(
                    searchText.isEmpty ? Color.csSecondaryTextColor : Color.csAccent
                )
            TextField("Search by name or symbol...", text: $searchText)
                .foregroundStyle(Color.csAccent)
                .autocorrectionDisabled(true)
                .overlay(alignment: .trailing) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(Color.csAccent)
                        .padding()
                        .offset(x: 10.0)
                        .opacity(searchText.isEmpty ? 0 : 1)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.csBackgroundColor)
                .shadow(color: Color.csAccent.opacity(0.15), radius: 10, x: 0.0)
        )
        .padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
