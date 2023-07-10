//
//  WalletPayment.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/8/23.
//

import SwiftUI

struct WalletPayment: View {
    
    @EnvironmentObject var registrationVM:RegisterViewModel
    
    var tokens = ["CELO", "cUSD", "cEUR"]
    
    var body: some View {
        VStack {
            Text("You will be able to change your houly rate & payment in settings.").font(.caption).bold()
            Section {
                HStack {
                    Text("$ \(registrationVM.registerNewDriver.rate.fare)").font(.title2).bold()
                    Stepper("per hour", value:  $registrationVM.registerNewDriver.rate.fare, in: 18...100)
                }.padding(10)
                HStack{
                    Text("Payment").bold()
                    Spacer()
                    Picker("Payment", selection: $registrationVM.registerNewDriver.rate.token) {
                        ForEach(tokens,id:\.self) {
                            Text($0)
                        }
                    }.buttonStyle(.borderedProminent)
                }.padding(10)
            }
            Spacer()
            Divider().padding(20)
            Text("Optional").bold().padding(5)
           
            Text("Your Income will be sent to your vault address rather then your Crypto Ride Wallet.").font(.callout)
            
            TextField("0xabc | james.celo",text: $registrationVM.registerNewDriver.rate.vault).keyboardType(.default)
            Spacer()
            Button(action: {
                registrationVM.subview = .OverView
                registrationVM.selectedView = "paperplane.fill"
                registrationVM.buttonNumber += 1
            }, label: {
                Spacer()
                Text("Finish").bold()
                Spacer()
            }).buttonStyle(.borderedProminent)
            .padding(10)
            
        }.navigationTitle("Payment & Rate")
            .textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .padding()
    }
}

struct WalletPayment_Previews: PreviewProvider {
    static var previews: some View {
        WalletPayment()
    }
}
