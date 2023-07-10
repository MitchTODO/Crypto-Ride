//
//  Authentication.swift
//  Crypto-Ride-Passenger
//
//  Created by mitchell tucker on 7/7/23.
//

import SwiftUI


class Authentication:ObservableObject {
    
    enum ViewState {
        case login
        case register
        case main
    }

    @Published var appState:ViewState = .login // default view is login
    
    func updateAuthState(goto:ViewState) {
        withAnimation {
            DispatchQueue.main.async { [self] in
                appState = goto
            }
        }
    }
}
