//
//  Network.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/11/23.
//

import Foundation
import BigInt

let alfajoresTestnet = Network(chainId: BigUInt(44787) , rpcEndpoint: "https://alfajores-forno.celo-testnet.org")

let webSocketURI = "wss://alfajores-forno.celo-testnet.org/ws"

struct Network {
    let chainId:BigUInt
    let rpcEndpoint:String
}

