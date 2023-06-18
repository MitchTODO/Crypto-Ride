//
//  ProfileViewModel.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 10/21/22.
//

import Foundation
import BigInt
import CoreImage.CIFilterBuiltins
import web3swift
import SwiftUI
import PhotosUI
import CoreTransferable


@MainActor
class ProfileViewModel:ObservableObject {
    
    @Published var driverInfo:DriverInfo?
    
    @Published var isLoading = false
    @Published var error:ContractError? = nil
    
    // Token Transfer variables
    @Published var toAddress = ""

    // Check if social connect phone number is used
    @Published var usingPhoneNumber = false
    @Published var lookupAddress = ""
    
    @Published var amount = ""
    @Published var password = ""
    @Published var tokenSelected = "cUSD"
    
    var userPhoneNumber = ""
    
    // Qr code generator
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    init() {
        // get driver rate price
        getDriverRate()
        
        let defaults = UserDefaults.standard
        userPhoneNumber = defaults.string(forKey: "phoneNumber") ?? ""
        
        // testing purchasing masa
        // purchaseName()
    }
    
    // MARK: getExtension
    /// Registers driver address to ride manager smart contract
    ///
    /// - Returns:
    ///         - Escaping <TranscationSendingResult>
    public func getExtension() {
        let params = [] as [AnyObject]
        ContractServices.shared.read(contractId: .SoulName, method: "extension", parameters: params) { result in
            print(result)
        }
    }
    
    // MARK: getPaymentMethods
    /// Registers driver address to ride manager smart contract
    ///
    /// - Returns:
    ///         - Escaping <TranscationSendingResult>
    public func getPaymentMethods() {
        let params = [] as [AnyObject]
        ContractServices.shared.read(contractId: .SoulStore, method: "getEnabledPaymentMethods", parameters: params) { result in
            print(result)
        }
    }

    
    public func checkSoulNameAvaibility(name:String) {
        let params = [name] as [AnyObject]
        
        ContractServices.shared.read(contractId: .SoulBound, method: "isAvailable", parameters: params) { result in
            DispatchQueue.main.async { [unowned self] in
                switch(result){
                case .success(let result):
                    let rawValue = result["available"] as! NSNumber
                    print(Bool(exactly: rawValue)!)
                    //avaibility = Bool(exactly:rawValue)!
                    //nameAvaiable = name // set soulname
                case.failure(let error):
                    print(error)
                    // TODO SET ERROR on
                }
            }
        }
    }
    
    
    public func purchaseName() {
        let ethAddress = ContractServices.shared.getWallet()
        let params = ["0x0000000000000000000000000000000000000000","jsmith",4,1,"ar://local",ethAddress.address,"0x92dd3039ef7a0da25376282362b087c27751f7e9c7cf2d76443c529baab1c3af178b5ed2b9b14747d3448f882e6a4df33d714ed2ff3a2c56795661e0e0d85fb21c"] as [AnyObject]
        ContractServices.shared.write(contractId:.SoulStore, method: "purchaseIdentityAndName", parameters: params, password: "123") {
            result in
            DispatchQueue.main.async { [unowned self] in
                switch(result){
                case .success(let result):
                    print(result)
                    
                case .failure(let error):
                    print(error)
                    self.error = error
                }
            }
        }
        
    }
    

    // MARK: getDriverRate
    /// Get driver rate from ride manager contract
    /// - Returns:
    ///         - Escaping <TranscationSendingResult>
    public func getDriverRate() {
        isLoading = true
        let ethAddress = ContractServices.shared.getWallet()
        
        let params = [ethAddress.address] as [AnyObject]
        
        ContractServices.shared.read(contractId: Contracts.RideManager, method: "getDriverRate", parameters: params)
        { result in
            DispatchQueue.main.async { [self] in
                isLoading = false
                switch(result){
                case .success(let result):
                    let rawRate = result["0"] as! [AnyObject]
                    
                    let isDriver = rawRate[0] as! NSNumber
                    let rate = rawRate[1] as! BigUInt
                    
                    let profileAssetUrl = rawRate[2] as! String
                    var splitProfileAsset = profileAssetUrl.split(separator: " ")
                    let profileCid = splitProfileAsset.popLast()!.trimmingCharacters(in: .whitespacesAndNewlines)
                    print(profileCid)
                    
                    var profileDescription = ""
                    for nPart in splitProfileAsset {
                        profileDescription += " \(nPart)"
                    }
                    print(profileDescription)

                    let infoAssetUrl = rawRate[3] as! String
                    var carAssetSplit = infoAssetUrl.split(separator: " ")
                    let carCid = carAssetSplit.popLast()!.trimmingCharacters(in: .whitespacesAndNewlines)
                    print(carCid)
                    
                    var carDescription = ""
                    for part in carAssetSplit {
                        carDescription += " \(part)"
                    }
                    print(carDescription)
                    
                    driverInfo = DriverInfo(
                        address: ethAddress.address,
                        isDriver: Bool(exactly: isDriver)!,
                        rate: rate,
                        carAssetLink: carDescription,
                        infoAssetLink: profileDescription)
                    
                case .failure(let error):
                    self.error = error
                }
            }
        }
    }
    

    // MARK: transfer
    /// Transfers tokens from passengers wallet  to `toAddress`
    /// Note: currently only transfers cUSD token
    ///
    /// - Returns:
    ///              - @escaping(TranscationSendingResult)
    func transfer(completion:@escaping(TransactionSendingResult) -> Void) {
        let amount = Web3.Utils.parseToBigUInt(amount, units: .eth)
        var to = toAddress
        
        if usingPhoneNumber {
            to = lookupAddress
        }
 
        guard let ethAddress = EthereumAddress(to) else {
            self.error = ContractError(title: "Failed", description: "Invalid To Address")
            return
        }
        
        let params = [ethAddress.address, amount] as [AnyObject]
        
        // TODO improve token identification
        var tokenContract:Contracts = .Celo
        if tokenSelected == "cUSD" {
            tokenContract = .CUSD
        }
            
        ContractServices.shared.write(contractId: tokenContract, method: "transfer", parameters: params, password: password) {
            result in
            DispatchQueue.main.async { [unowned self] in
                switch(result){
                case .success(let result):
                    print(result)
                    completion(result)
                case .failure(let error):
                    print(error)
                    self.error = error
                }
            }
        }
    }
}
