//
//  CryptoRide_DriverApp.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 10/21/22.
//

import SwiftUI
import FirebaseCore


@main
struct CryptoRide_DriverApp: App {
    @StateObject var authentication = Authentication()
    @StateObject var appState = AppState()

    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            switch(appState.state) {
            case .logout:
                LoginView()
                    .environmentObject(appState)
                    .environmentObject(authentication)
                
            case .login:
                ContentView(password: authentication.password)
                    .environmentObject(appState)
                    .environmentObject(authentication)
                
            case .register:
                RegistrationView()
                    .environmentObject(appState)
                    .environmentObject(authentication)
            }
        }
    }
}
