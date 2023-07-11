//
//  RegisterViewModel.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/7/23.
//

import Foundation
import BigInt
import CoreImage.CIFilterBuiltins
import web3swift
import SwiftUI

struct DriverInfo {
    var address:String?
    var isDriver:Bool?
    var rate:BigUInt?
    var carAssetLink:String?
    var infoAssetLink:String?
}

struct Profile {
    var name = "Morgan Freeman"
    var phoneNumber = "+1 890 324 8457"
    var soulName = "morgan.soul"
    var socialHandle = "@morgan23"
    var profileImageData:Data?
}

struct Vehicle {
    var year = "2021"
    var make = "BMW"
    var model = "M5"
    var color = "White"
    var seatNumber = 4
    var vehicleImageData:Data?
}

struct Location {
    var zone = 1 // miles
    var city = "Denver"
    var state = "CO"
}

struct Rate{
    var fare = 20
    var token = "cUSD"
    var vault = "0x00123abc"
}

struct NewWallet {
    var password = ""
    var repassword = ""
    var mnemonics = ""
}

struct RegisterDriver {
    var profile = Profile()
    var vehicle = Vehicle()
    var location = Location()
    var wallet = NewWallet()
    var rate = Rate()
}

@MainActor
class RegisterViewModel:ObservableObject {
    
    @Published var subview:SubView = .DriverProfile
    
    @Published var selectedView = "person.fill"
    
    @Published var buttonNumber = 1


    enum ViewState {
        case login
        case register
        case main
    }
    
    // registration subviews
    enum SubView {
        case DriverProfile
        case VehicleProfile
        case LocationProfile
        case PaymentProfile
        case OverView
    }
    
    @Published var walletSubViews:WalletSubViews = .WalletGenerate
    
    // wallet subviews
    enum WalletSubViews {
        case WalletGenerate
        case WalletOverview
        case WalletPayment
    }
    

    // progress during loading
    @Published var isloading = false
    // keyStore errors
    @Published var error:WalletServices.KeyStoreServicesError?
    // Circle Models
    @Published var profilePic = CircleModel()
    @Published var vehiclePic = CircleModel()
    // Register new driver
    @Published var registerNewDriver = RegisterDriver()
    
    @Published var newWalletAddress = ""

    // MARK: genKeyStore
    /// Generate key store
    public func genKeyStore(completion:@escaping(Bool) -> Void ) {
        // login credentials
        var credentials = Credentials()
        credentials.password = registerNewDriver.wallet.password
        WalletServices.shared.createKeyStore(credentials: credentials) { [unowned self] (result:Result<(String,String), WalletServices.KeyStoreServicesError>) in
            DispatchQueue.main.async { [unowned self] in
                switch result {
                case .success(let walletDetails):
                    // show mnemonices
                    self.registerNewDriver.wallet.mnemonics = walletDetails.0
                    self.newWalletAddress = walletDetails.1
                    completion(true)
                case .failure(let authError):
                    self.error = authError
                    completion(false)
                }
            }
        }
    }
}
