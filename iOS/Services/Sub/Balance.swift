//
//  Balance.swift
//  CryptoRide
//
//  Created by mitchell tucker on 10/31/22.
//

import BigInt
import web3swift
import Web3Core

// MARK: Balance
/// Manages token balances
class Balance:ObservableObject {
    // Token balances
    @Published var cUSD:String = ""
    @Published var CELO:String = ""
    
    @Published var isLoading = false
    
    // MARK: getTokenBalance
    /// Read balance from given a toke contract
    public func getTokenBalance(address:String,token:Contracts) {
        isLoading = true
        let params = [address] as [AnyObject]
        
        ContractServices.shared.read(contractId:token, method:  CusdMethods.balanceOf.rawValue, parameters: params) { result in
            DispatchQueue.main.async { [self] in
                isLoading = false
                switch(result) {
                case .success(let result):
                    let rawBalance = result["balance"] as! BigUInt
                    if token == .CUSD {
                        //Web3.Utils.Units.
                        cUSD = rawBalance.description
                        //Web3.Utils.formatToEthereumUnits(rawBalance, toUnits: .eth, decimals: 3)!
                    }else{
                        CELO = rawBalance.description
                        //Web3.Utils.formatToEthereumUnits(rawBalance, toUnits: .eth, decimals: 3)!
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
