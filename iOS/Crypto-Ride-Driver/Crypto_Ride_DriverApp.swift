//
//  Crypto_Ride_DriverApp.swift
//  Crypto-Ride-Driver
//
//  Created by mitchell tucker on 7/7/23.
//

import SwiftUI
// Import FireBase

@main
struct Crypto_Ride_DriverApp: App {
    @StateObject var authentication = Authentication()
    
    init() {
        // init firebase
    }
    
    var body: some Scene {
        WindowGroup {
            switch (authentication.appState) {
            case .main:
                ContentView()
                    .environmentObject(authentication)
            case .login:
                LoginView()
                    .environmentObject(authentication)
            case .register:
                RegisterView()
                    .environmentObject(authentication)
                // register view
            }
        }
    }
}
