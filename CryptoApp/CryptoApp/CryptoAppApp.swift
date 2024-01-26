//
//  CryptoAppApp.swift
//  CryptoApp
//
//  Created by Muhammadjon Madaminov on 16/09/23.
//

import SwiftUI

@main
struct CryptoAppApp: App {
    @StateObject var vm = HomeViewModel()
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.csAccent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.csAccent)]
    }
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden)
            }
            .environmentObject(vm)
        }
    }
}
