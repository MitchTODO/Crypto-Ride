//
//  RegOverView.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/8/23.
//

import SwiftUI

struct RegOverView: View {
    
    @EnvironmentObject var registrationVM:RegisterViewModel
    
    var body: some View {
        ScrollView {
            VStack() {
                Text("Driver Profile")
                    .padding(5)
                    .multilineTextAlignment(.center)
                    .font(.title2).bold()
                HStack{
                    VStack(alignment: .leading, spacing: 10){
                        Text("Name").bold()
                        Text("Phone Number").bold()
                        Text("Social Handle").bold()
                        Text("Soul Name").bold()
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 10) {
                        Text(registrationVM.registerNewDriver.profile.name)
                        Text(registrationVM.registerNewDriver.profile.phoneNumber)
                        Text(registrationVM.registerNewDriver.profile.socialHandle)
                        Text(registrationVM.registerNewDriver.profile.soulName)
                        
                    }
      
                }
            }
            .padding(30)
            .background(.secondary)
            .cornerRadius(15)
            
            VStack() {
                Text("Vehicle Profile")
                    .padding(5)
                    .font(.title2)
                    .bold()
                HStack{
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Year").bold()
                        Text("Make").bold()
                        Text("Model").bold()
                        Text("Color").bold()
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 10) {
                        Text(registrationVM.registerNewDriver.vehicle.year)
                        Text(registrationVM.registerNewDriver.vehicle.make)
                        Text(registrationVM.registerNewDriver.vehicle.model)
                        Text(registrationVM.registerNewDriver.vehicle.color)
                    }
                }
            }
            .padding(30)
            .background(.secondary)
            .cornerRadius(15)
            
            VStack() {
                Text("Location")
                    .padding(5)
                    .font(.title2)
                    .bold()
                HStack{
                    VStack(alignment: .leading, spacing: 10) {
                        Text("City").bold()
                        Text("State").bold()
                        Text("Work Radius").bold()
                    }
                    Spacer()
                    VStack(alignment: .leading, spacing: 10) {
                        Text(registrationVM.registerNewDriver.location.city)
                        Text(registrationVM.registerNewDriver.location.state)
                        Text("\(registrationVM.registerNewDriver.location.zone)")
                    }
                }
            }
            .padding(30)
            .background(.secondary)
            .cornerRadius(15)
            
            VStack(){
                Text("Crypto Wallet")
                    .padding(5)
                    .font(.title2)
                    .bold()
                HStack{
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Fare Price").bold()
                        Text("Vault Address").bold()
                        Text("Payment").bold()
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 10) {
                        Text("\(registrationVM.registerNewDriver.rate.fare)")
                        Text(registrationVM.registerNewDriver.rate.vault)
                        Text("\(registrationVM.registerNewDriver.rate.token)")
                    }
                }
            }
            .padding(30)
            .background(.secondary)
            .cornerRadius(15)
            
            Button(action: {
                print("register")
            }, label: {
                Spacer()
                Text("Register").bold().padding(6)
                Spacer()
            }).buttonStyle(.borderedProminent)
        }
    }
}

struct RegOverView_Previews: PreviewProvider {
    static var previews: some View {
        RegOverView()
    }
}
