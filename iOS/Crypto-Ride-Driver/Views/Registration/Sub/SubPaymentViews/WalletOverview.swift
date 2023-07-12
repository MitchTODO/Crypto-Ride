//
//  WalletOverview.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/8/23.
//

import SwiftUI

struct WalletOverview: View {
    
    @EnvironmentObject var registrationVM:RegisterViewModel
    @StateObject var balance = Balance()
    
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
            
            HStack{
                HStack{
                    Image("cUSD")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 30, alignment: .center)
                    Text("\(balance.cUSD)")
                    
                }
                Divider()
                HStack{
                    Image("Celo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40, alignment: .center)
                    Text("\(balance.CELO)")
                    
                }
                Button{
                    balance.getTokenBalance(address: registrationVM.newWalletAddress, token: .CUSD)
                    balance.getTokenBalance(address: registrationVM.newWalletAddress, token: .Celo)
                    
                }label: {
                    Image(systemName: "arrow.clockwise.circle.fill")
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .frame(width: 20, height: 20, alignment: .center)
                }.buttonStyle(.borderless)
            }.task {
                balance.getTokenBalance(address: registrationVM.newWalletAddress, token: .CUSD)
                balance.getTokenBalance(address: registrationVM.newWalletAddress, token: .Celo)
                
            }
            
            Spacer()
            Text("Write Down your recovery phase and store it in a safe location")
                .padding(5)
                .multilineTextAlignment(.center)
            
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
              .disabled(balance.CELO.isEmpty)
            
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
