//
//  LoginViewModel.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/7/23.
//

import Foundation
import web3swift

class LoginViewModel:ObservableObject {
    
    // login credentials
    @Published var credentials = Credentials()
    // progress during loading
    @Published var isloading = false
    // keyStore errors
    @Published var error:WalletServices.KeyStoreServicesError?
    
    // bool if keyStore exist on device
    //@Published var hasKeyStore = WalletServices.shared.hasKeyStore
    // mnemonics for newly created wallets
    // @Published var mnemonics = ""
    
    func checkKeyStore() -> Bool {
        return WalletServices.shared.hasKeyStore
    }
    
    // MARK: login
    func login(completion: @escaping(Authentication.ViewState) -> Void) {
        // Check and verify keystore
        if checkKeyStore() {
            // Checksum with existing keystore
            let keyStore = WalletServices.shared.getKeyManager()
            WalletServices.shared.verifyKeyStore(keyStore: keyStore, credentials: credentials) {  [unowned self] (result:Result<Bool, WalletServices.KeyStoreServicesError>) in
                DispatchQueue.main.async { [unowned self] in
                    isloading = false
                    switch result {
                        case .success:
                            // on success move state to main view
                            completion(.main)
                        case .failure(let authError):
                            // on failure keep on view
                            credentials = Credentials()
                            error = authError
                            completion(.login)
                    }
                }
            }
        } else {
            // Create new key store in registeration
            completion(.register)
        }
    
    }
}
