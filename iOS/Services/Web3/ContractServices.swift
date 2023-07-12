//
//  Contract.swift
//  CryptoRide-Passenger CryptoRide-Driver
//
//  Created by mitchell tucker on 10/13/22.
//

import Foundation
import web3swift
import Web3Core

import BigInt


class ContractServices {
    
    // Shared contract instance
    static let shared = ContractServices()
    
    // Web3 instance
    private var w3:Web3?
    private var wallet:Wallet?
    
    
    // MARK: getContract
    /// match contract enum to web3 contract
    ///
    ///
    /// - Parameters :
    ///              `contract` : Contracts  Enum - Contract  to get
    ///
    /// - Returns: web3.web3contract of related contract
    /// 
    private func getContract(contract:Contracts) async throws -> Web3.Contract {
        
        // Get wallet data from keystore manager
        let keystore = WalletServices.shared.keystoreManager!
        let keyData = try! JSONEncoder().encode(keystore.keystoreParams);
        
        let address = keystore.addresses!.first!.address

        wallet = Wallet(address: address, data: keyData, name: "Driver", isHD: true)
        
        // add keystore to keystoreManager used for signing tx
        let keystoreManager = KeystoreManager([keystore])
        
        // Set up web provider
        guard let provider = await Web3HttpProvider(URL(string: alfajoresTestnet.rpcEndpoint)!, network: .Custom(networkID: alfajoresTestnet.chainId)) else {
            // failed to create provider
            throw ContractError(title: "Provider Error", description: "Failed to init provider.")
        }
        
        w3 = Web3(provider: provider)
        w3!.addKeystoreManager(keystoreManager)
        
        // TODO change erc20 abi with celo's token abi
        // Construct contract address
        switch(contract) {
        case Contracts.RideManager:
            return(w3!.contract(rideManagerAbi, at: rideManagerAddress, abiVersion:abiVersion)!)
        case Contracts.CUSD:
            return(w3!.contract(Web3.Utils.erc20ABI, at: cUSD , abiVersion: abiVersion)!)
        case Contracts.Celo:
            return(w3!.contract(Web3.Utils.erc20ABI, at: CELO , abiVersion: abiVersion)!)
        }

    }
    
    // MARK: read
    /// async method to read data from a given contract method
    ///
    ///
    /// - Parameters :
    ///               `contractId` : Enum type - as contract used to read from
    ///
    ///               `method` : String - called contract methods
    ///
    ///               `parameters` :  [AnyObject] - parameters associated with contract call
    ///
    /// - Returns: completion: <String:Any> on success , `ContractError` on failure
    ///
    func read(contractId:Contracts,method:String,parameters:[AnyObject],completion:@escaping(Result<[String:Any],ContractError>) -> Void) {
        Task {
            do {
                let contract = try await getContract(contract: contractId)
                let from = EthereumAddress(wallet!.address)
                
                let extraData: Data = Data() // Extra data for contract method
                
                guard let readOp = contract.createReadOperation(method,parameters: parameters,extraData: extraData) else {
                    // failed to create tx
                    throw ContractError(title: "Failed to Read", description: "No Read")
                }
                readOp.transaction.from = from
                
                let response = try await readOp.callContractMethod()
                completion(.success(response))
            } catch {
                completion(.failure(ErrorFilter.typeCheck(error: error)))
            }
        }
    }
    
    // MARK: write
    /// async method to write data to a given contract method
    ///
    /// - Parameters :
    ///                 - `contractId` : Enum type - as contract used to read from
    ///                 - `method` : String - called contract methods
    ///                 - `parameters` :  [AnyObject] - parameters associated with contract call
    ///                 - `password`:String - password of keymanager used to sign transaction
    ///
    /// - Returns: completion: `TransactionSendingResult` on success , `ContractError` on failure
    ///
    func write(contractId:Contracts,method:String,parameters:[AnyObject],password:String,_ value:BigUInt?,completion:@escaping(Result<TransactionSendingResult,ContractError>) -> Void) {
        
        Task {
            do {
                let contract = try await getContract(contract: contractId)
                let from = EthereumAddress(wallet!.address)
                let extraData: Data = Data() // Extra data for contract method
                
                //var transaction:CodableTransaction = .emptyTransaction
        
                //transaction.from = from ?? transaction.sender
                //if value != nil {
                //    transaction.value = value!
                //}

                //transaction.gasPrice = BigUInt(20000000000)
                //transaction.gasLimit = BigUInt(878423)
                
                guard let writeOp = contract.createWriteOperation(method,parameters: parameters,extraData: extraData) else {
                    throw ContractError(title: "Failed to Write", description: "No Write")
                }
                
                //print(from)
                writeOp.transaction.from = from
                writeOp.transaction.gasPrice = BigUInt(20000000000)
                writeOp.transaction.gasLimit = BigUInt(878423)
    
                let response = try await writeOp.writeToChain(password: "",sendRaw: true)
                completion(.success(response))
            }catch {
                completion(.failure(ErrorFilter.typeCheck(error: error)))
            }
        }
    }
}
