//
//  RegistrationViewModel.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 6/8/23.
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
    var profileImageData:Data?
}

struct Vehicle {
    var year = "2021"
    var makeModel = "BMW M5"
    var color = "White"
    var seatNumber = 4
    var vehicleImageData:Data?
}

struct Rate{
    var fare = 20
}

struct NewWallet {
    var password = ""
    var repassword = ""
    var mnemonics = ""
}

struct RegisterDriver {
    var profile = Profile()
    var vehicle = Vehicle()
    var wallet = NewWallet()
    var rate = Rate()
}

@MainActor
class RegistrationViewModel:ObservableObject {
    
    @Published var credentials = Credentials()
    @Published var registerNewDriver = RegisterDriver()

    @Published var vehiclePic = ProfileModel()
    @Published var profilePic = ProfileModel()
    
    @Published var hasKeyStore = WalletServices.shared.hasKeyStore
    
    // Address
    @Published var address = ""
    @Published var readyToSend = false
    
    // Errors
    @Published var error:ContractError? = nil
    @Published var localError:String? = nil
    
    // Token balances
    @Published var cUSD:String = ""
    @Published var CELO:String = ""
    @Published var isBalanceLoading = false
    
    // Soul Name
    @Published var avaibilityIsLoading = false
    @Published var avaibility = false
    @Published var nameAvaiable = ""
   
    
    // MARK: genKeyStore
    /// Generate key store
    public func genKeyStore(completion:@escaping(Bool) -> Void ) {
        credentials.password = registerNewDriver.wallet.password
        WalletServices.shared.createKeyStore(credentials: credentials) { [unowned self] (result:Result<String, WalletServices.KeyStoreServicesError>) in
            DispatchQueue.main.async { [unowned self] in
                switch result {
                case .success(let mnemonics):
                    // show mnemonices
                    self.registerNewDriver.wallet.mnemonics = mnemonics
                    hasKeyStore = true // update keystore
                    completion(true)
                case .failure(let authError):
                    completion(false)
                }
            }
        }
    }
    
 
  
    // MARK: registerDriver
    /// Registers driver address to ride manager smart contract
    ///
    /// - Parameters:
    ///         `rate` Integer : drivers flate fee per hour of drive time
    ///         `name`String:   name of driver
    ///         `car` String : car description
    ///
    /// - Returns:
    ///         - Escaping <TranscationSendingResult>
    public func registerDriver(rate:Int,name:String,car:String, completion:@escaping(TransactionSendingResult) -> Void) {
        let params = [rate,name,car] as [AnyObject]
            ContractServices.shared.write(contractId: .RideManager, method: "addDriver", parameters: params, password: registerNewDriver.wallet.password) { result in
                DispatchQueue.main.async { [unowned self] in
                    switch(result){
                    case .success(let result):
                        completion(result)
                    case .failure(let error):
                        //print(error)
                        self.error = error
                    }
            }
        }
    }
    

    public func namePricePerYear() {
        let account = ContractServices.shared.getWallet().address
        let params = [account] as [AnyObject]
        ContractServices.shared.read(contractId: .SoulStore, method: "addAuthority", parameters: params) { result in
            switch(result){
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
            }
        }
    }
    

    public func mintPrice() {
        let account = ContractServices.shared.getWallet().address
        
        let params = ["0x1B830e25CcBf8C0D512653800a294876fA658c67",account,"morgan",6,1,"url","0x3c8D9f130970358b7E8cbc1DbD0a1EbA6EBE368F"] as [AnyObject]
        ContractServices.shared.read(contractId: .SoulStore, method: "purchaseName", parameters: params) { result in
            switch(result){
                case .success(let value):
                    print(value)
                case .failure(let error):
                    print(error)
            }
        }
    }

    
    
    
    public func registerSoulName(to:String,name:String,years:Int,tokenURI:String, completion:@escaping(TransactionSendingResult) -> Void) {
        let params = [to,name,years,tokenURI] as [AnyObject]
        //print("Sending with soulname \(name)")
        //print("Sending with password \(registerNewDriver.wallet.password)")
        ContractServices.shared.write(contractId: .SoulStore, method: "mint", parameters: params, password: registerNewDriver.wallet.password) { result in
            DispatchQueue.main.async { [unowned self] in
                switch(result){
                case .success(let result):
                    //print(result)
                    completion(result)
                case .failure(let error):
                    //print(error)
                    self.error = error
                }
            }
        }
    }

    
    public func checkSoulNameAvaibility(name:String) {
        let params = [name] as [AnyObject]
        
        ContractServices.shared.read(contractId: .SoulBound, method: "isAvailable", parameters: params) { result in
            DispatchQueue.main.async { [unowned self] in
                avaibilityIsLoading = false
                switch(result){
                case .success(let result):
                    let rawValue = result["available"] as! NSNumber
                    avaibility = Bool(exactly:rawValue)!
                    nameAvaiable = name // set soulname
                case.failure(let error):
                    print(error)
                    // TODO SET ERROR on
                }
            }
            
        }
    }
    
    
    // MARK: registerSocialConnect
    ///  Look up social connect phone number
    ///
    ///  - Parameters:
    ///             `phone`: String
    ///
    ///  - Returns:
    ///             - Escaping <Bool, Error>
    func registerSocialConnect(phone:String, completion: @escaping(Result<Bool,Error>) -> Void) {
        let url = URL(string: "http://localhost:3000/register")!
        var request = URLRequest(url:url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json",forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        // get wallet address
        let account = WalletServices.shared.getKeyManager().addresses!.first!.address
        // fix phone number
        let noSpace = phone.replacingOccurrences(of: " ", with: "")
        let parameters: [String:Any] = [
            "phone": noSpace,
            "account": account
        ]
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else {
                completion(.failure(error!))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            completion(.success(true))
        }
        task.resume()
    }
    
    
    // MARK: uploadImage
    /// Uploades image to ipfs
    ///
    /// - Parameters:
    ///             `url`: String
    ///
    /// - Returns:
    ///     - Escaping <String, Error>
    ///completion:@escaping(Result<String,Error>)
    func uploadImage(paramName: String, fileName: String, image: UIImage, completion:@escaping(String) -> Void) {
        let url = URL(string: "http://192.168.7.60:3000/upload")!

        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString

        let session = URLSession.shared

        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"

        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(paramName)\"; fileName=\"\(fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(image.pngData()!)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        // Send a POST request to the URL, with the data we created earlier
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            if error == nil {
                let cid = String(decoding: responseData!, as: UTF8.self)
                completion(cid)
            }
        }).resume()

    }
    
    // MARK: getTokenBalance
    /// Read balance from given a toke contract
    public func getTokenBalance(_ tokenContract:Contracts) {
        isBalanceLoading = true
        let ethAddress = ContractServices.shared.getWallet()
        let params = [ethAddress.address] as [AnyObject]
        ContractServices.shared.read(contractId:tokenContract, method:  CusdMethods.balanceOf.rawValue, parameters: params) { result in
            DispatchQueue.main.async { [unowned self] in
                isBalanceLoading = false
                switch(result) {
                case .success(let result):
                    let rawBalance = result["balance"] as! BigUInt
                    if tokenContract == .CUSD{
                        cUSD = Web3.Utils.formatToEthereumUnits(rawBalance, toUnits: .eth, decimals: 3)!
                    }else{
                        CELO = Web3.Utils.formatToEthereumUnits(rawBalance, toUnits: .eth, decimals: 3)!
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
