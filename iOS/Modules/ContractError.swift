//
//  ContractError.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/10/23.
//

import Foundation

// MARK: ContractError
/// Contract error used to consolidates different error types into singler error
struct ContractError:Error,LocalizedError,Identifiable {
    var id:String {description}
    let title:String
    let description:String
}
