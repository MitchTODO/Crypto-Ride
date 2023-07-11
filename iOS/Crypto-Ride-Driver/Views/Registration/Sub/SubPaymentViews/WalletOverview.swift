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
                    .font(.headline)
                Button(action: {
                    print("name")
                }, label: {
                    Image(systemName: "info.circle.fill")
                })
            }
            WalletQRCodeView(address: registrationVM.newWalletAddress, phone:"")
            Spacer()
            Text("Write Down your recovery phase and store it in a safe location")
                .multilineTextAlignment(.center)
                .padding(5)
            Text("IT WILL ONLY BE DISPLAYED ONCE.")
                .padding(5)
                .font(.headline)
            
            VStack {
                HStack {
                    Spacer()
                    Text(registrationVM.registerNewDriver.wallet.mnemonics)
                        .multilineTextAlignment(.center)
                        .bold()
                        .lineSpacing(5)
                        .padding(10)
                    
                    Spacer()
                }
            }.background(.secondary)
                .cornerRadius(5)
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
            .padding(10)
    }
}

struct WalletOverview_Previews: PreviewProvider {
    static var previews: some View {
        WalletOverview()
    }
}
