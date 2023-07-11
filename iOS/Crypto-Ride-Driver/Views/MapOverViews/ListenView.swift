//
//  ActivateDriverView.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/10/23.
//

import SwiftUI

struct ListenView: View {
    
    @EnvironmentObject var rideService:RideService
    
    var body: some View {
        Button(action: {
            print("listen")
            //rideService.driverState =
        }, label: {
            Text("Listen For New Rides")
                .font(.title2)
                .bold()
        })
    }
}

