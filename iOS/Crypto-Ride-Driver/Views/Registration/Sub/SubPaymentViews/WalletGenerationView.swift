//
//  WalletGenerationView.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/8/23.
//

import SwiftUI

struct WalletGenerationView: View {
    
    @EnvironmentObject var registrationVM:RegisterViewModel
    @State var isGenWallet = false
    
    var body: some View {
        VStack(alignment: .center){
            if isGenWallet {
                ProgressView().tint(.secondary)
            }else{
                Text("Generate Wallet").font(.title2)
                Button(action: {
                    print("FaceId")
                    //registrationVM.subview = .PaymentProfile
                }, label: {
                    Text("FaceId")
                        .padding(10)
                }).buttonStyle(.borderedProminent)
                    .padding(10)
                Text("Or").font(.title2)
                Section {
                    VStack(alignment: .leading){
                        Text("Password")
                        TextField("Password", text: $registrationVM.registerNewDriver.wallet.password)
                        Text("Re-Password")
                        TextField("Re-Password", text: $registrationVM.registerNewDriver.wallet.repassword)
                    }.textFieldStyle(.roundedBorder)
                        .disableAutocorrection(true)
                        .padding()
                }
                Spacer()
                Button(action: {
                    isGenWallet = true
                    // gen keyStore
                    registrationVM.genKeyStore() { isSuccess in
                        isGenWallet = false
                        if isSuccess {
                            registrationVM.walletSubViews = .WalletOverview
                        }
                    }
                }, label: {
                    Text("Generate")
                        .bold()
                        .padding(10)
                }).buttonStyle(.borderedProminent)
                Spacer()
            }
        }.padding(10)
    }
}

struct WalletGenerationView_Previews: PreviewProvider {
    static var previews: some View {
        WalletGenerationView()
    }
}
