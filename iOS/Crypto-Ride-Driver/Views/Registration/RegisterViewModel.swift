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
    var soulName = "morgan"
    var socialHandle = ""
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
    var city = ""
    var state = ""
}

struct Rate{
    var fare = 20
    var token = ""
    var vault = ""
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
    
    // login credentials
    @Published var credentials = Credentials()
    // progress during loading
    @Published var isloading = false
    // keyStore errors
    @Published var error:WalletServices.KeyStoreServicesError?
    // Circle Models
    @Published var profilePic = CircleModel()
    @Published var vehiclePic = CircleModel()
    // Register new driver
    @Published var registerNewDriver = RegisterDriver()
    

}