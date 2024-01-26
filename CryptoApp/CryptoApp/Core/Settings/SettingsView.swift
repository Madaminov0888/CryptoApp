//
//  SettingsView.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 10/01/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var appearance: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Toggle(isOn: $appearance, label: {
                    Text("Dark Theme")
                })
            }
            .onChange(of: appearance, { oldValue, newValue in
                appearance.toggle()
            })
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            }
        }
        .preferredColorScheme(appearance ? .dark : .light)
    }
}

#Preview {
    SettingsView()
}
