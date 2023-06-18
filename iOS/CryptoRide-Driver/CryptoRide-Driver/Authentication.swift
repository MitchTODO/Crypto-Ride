//
//  Authentication.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 10/23/22.
//

import SwiftUI

// MARK: Authentication
/// Authentication object for login - out service
class Authentication:ObservableObject {
    @Published var isValidated = false
    var password = ""
    
    func updateValidation(success:Bool, phoneNumber:String?, password:String?, mnemonic:String?) {
        withAnimation {
            DispatchQueue.main.async { [self] in
                isValidated = success
                self.password = password ?? ""
            }
        }
    }
}