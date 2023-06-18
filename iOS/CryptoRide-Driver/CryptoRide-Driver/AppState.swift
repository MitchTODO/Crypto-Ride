//
//  AppState.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 6/11/23.
//

import Foundation
import SwiftUI

class AppState:ObservableObject {
    
    enum States {
        case register
        case login
        case logout
    }
    
    @Published var state:States = .logout
    
    func updateValidation(state:States) {
        withAnimation {
            self.state = state
        }
    }
}
