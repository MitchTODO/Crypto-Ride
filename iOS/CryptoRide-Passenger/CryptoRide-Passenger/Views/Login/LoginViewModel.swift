//
//  LoginViewModel.swift
//  CryptoRide-Passenger
//
//  Created by mitchell tucker on 10/28/22.
//

import Foundation
import web3swift

class LoginViewModel:ObservableObject {
    // login credentials
    @Published var credentials = Credentials()
    // progress during loading
    @Published var showProgressView = false
    // keyStore errors
    @Published var error:WalletServices.KeyStoreServicesError?
    // bool if keyStore exist on device
    @Published var hasKeyStore = WalletServices.shared.hasKeyStore
    // mnemonics for newly created wallets
    @Published var mnemonics = ""
    @Published var showMnemonic = false
    // register phone number
    @Published var registerPhoneNumber = false

    // MARK: login
    func login(completion: @escaping(Bool) -> Void) {
        hasKeyStore = WalletServices.shared.hasKeyStore
        let defaults = UserDefaults.standard
        // Create keystore if no keystore was found
        if !hasKeyStore {
            
            // Check if number is registered
            isNumberRegistered(phoneNumber: credentials.phoneNumber) { isRegistered in
                if isRegistered {return} // return if registed
            }
            
            WalletServices.shared.createKeyStore(credentials: credentials) { [unowned self] (result:Result<String, WalletServices.KeyStoreServicesError>) in
                    switch result {
                    case .success(let mnemonics):
                        
                        // Register phone number with new address
                        WalletServices.shared.registerSocialConnect(phone: credentials.phoneNumber) { [unowned self] (result:Result<Bool, Error>) in
                            DispatchQueue.main.async { [unowned self] in
                                switch result {
                                case .success(let result):
                                    // show mnemonices
                                    showMnemonic = true
                                    self.mnemonics = mnemonics
                                    showProgressView = false
                                    // save phone number into user defaults
                                    // this can be back checked
                                    defaults.set(credentials.phoneNumber, forKey: "phoneNumber")
                                    // get mnemonices from
                                    completion(true)
                                case .failure(let error):
                                    print(error)
                                }
                            }
                        }
                        
                    case .failure(let authError):
                        credentials = Credentials()
                        error = authError
                        completion(false)
                    }
            }
        } else {
            // Checksum with existing keystore
            let keyStore = WalletServices.shared.getKeyManager()
            WalletServices.shared.verifyKeyStore(keyStore: keyStore, credentials: credentials) {  [unowned self] (result:Result<Bool, WalletServices.KeyStoreServicesError>) in
                DispatchQueue.main.async { [unowned self] in
                showProgressView = false
                    switch result {
                    case .success:
                        completion(true)
                    case .failure(let authError):
                        credentials = Credentials()
                        error = authError
                        completion(false)
                    }
                }
            }
        }
    }
    
    
    private func isNumberRegistered(phoneNumber:String,completion: @escaping(Bool) -> Void) {
        // Check if phone number is already registered
        WalletServices.shared.lookUpNumber(number: phoneNumber) { (result:Result<[String],Error>) in
            switch result {
                case .success(let address):
                    if address.isEmpty {
                        completion(true)
                    }else{
                        completion(false)
                    }
                case .failure(let error):
                    completion(true)
            }
        }
    }

}
