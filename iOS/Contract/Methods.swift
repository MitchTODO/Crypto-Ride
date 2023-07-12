//
//  Methods.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/11/23.
//

import Foundation

enum CusdMethods:String {
    case balanceOf = "balanceOf"
}

// MARK: RideManagerMethods
/// RideManager smart contract methods used
enum RideManagerMethods:String {
    case getActiveRide = "getActiveRide"
    case getRide = "getRide"
    case driverTime = "driverTime"
    case isCanceled = "isCanceled"
    
    case announceRide = "announceRide"
    case driverAcceptsRide = "driverAcceptsRide"
    case passengerConfirmsPickUp = "passengerConfirmsPickUp"
    case driverConfirmsDropOff = "driverConfirmsDropOff"
    case passengerConfirmsDropOff = "passengerConfirmsDropOff"
    case cancelRide = "cancelRide"
    
    case getReputation = "getReputation"
    
    case setDriverWindow = "setDriverWindow"
    case pause = "pause"
    case unpause = "unpause"
    
    case isDriver = "isDriver"
    case getDriverRate = "getDriverRate"
    case addDriver = "addDriver"
    case removeDriver = "removeDriver"
    case updateRate = "updateRate"
    
    case approve = "approve"
}
