//
//  AppState.swift
//  CryptoRide-Passenger
//
//  Created by mitchell tucker on 6/14/23.
//

import Foundation
import SwiftUI

class AppState:ObservableObject {
    
    enum States {
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
