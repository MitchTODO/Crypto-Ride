//
//  WalletOverview.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/8/23.
//

import SwiftUI

struct WalletOverview: View {
    
    @EnvironmentObject var registrationVM:RegisterViewModel
    
    var body: some View {
        VStack {
            HStack{
                Text("Wallet Address")
                Button(action: {
                    print("name")
                }, label: {
                    Image(systemName: "info.circle.fill")
                })
            }
            WalletQRCodeView(address: "sdf", phone:"Number")
            Spacer()
            Text("Write Down your recovery phase and store it in a safe location").font(.caption)
            Text("IT WILL ONLY BE DISPLAYED ONCE.").font(.title3)
            
            VStack {
                HStack {
                    Spacer()
                    Text("recovery phase")
                    Spacer()
                }
               
            }.background(Color.gray)
                .buttonBorderShape(.roundedRectangle)
            Spacer()
            Button(action: {
                registrationVM.walletSubViews = .WalletPayment
            }, label: {
                Spacer()
                Text("Next").bold()
                Spacer()
            }).buttonStyle(.borderedProminent)
        }.navigationTitle("Recovery Phase")
            .textFieldStyle(.roundedBorder)
            .disableAutocorrection(true)
            .padding(5)
    }
}

struct WalletOverview_Previews: PreviewProvider {
    static var previews: some View {
        WalletOverview()
    }
}
