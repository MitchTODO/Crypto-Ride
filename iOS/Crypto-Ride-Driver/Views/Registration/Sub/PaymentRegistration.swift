//
//  PaymentRegistration.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/7/23.
//

import SwiftUI

struct PaymentRegistration: View {
    
    @EnvironmentObject var registrationVM:RegisterViewModel
    
    @State var password = ""
    @State var rePassword = ""
    
    // Switch sub views for wallet creation & payment views
    func switchSubView() -> AnyView {
        
        switch(registrationVM.walletSubViews) {
            case .WalletGenerate:
                return AnyView(
                    WalletGenerationView().environmentObject(registrationVM)
                )
            case .WalletOverview:
                return AnyView(
                    WalletOverview().environmentObject(registrationVM)
                )
            case .WalletPayment:
                return AnyView(
                    WalletPayment().environmentObject(registrationVM)
                )
        }
    }
    
    var body: some View {
        VStack {
            
            Text("Wallet Creation")
                .padding(8)
                .font(.title3)
                .bold()
            
            if (registrationVM.walletSubViews != .WalletPayment) {
                VStack(spacing: 8) {
                    Text("Your Crypto Wallet allows you to accept rides and get paid.")
                    Text("Dont be a Dummy, Important Info")
                    Text("Your profile and earnings are controlled by the wallet.").font(.footnote)
                    Text("Your Wallet is stored on this device and only recoverable through the recovery phase.").font(.footnote)
                    
                }.multilineTextAlignment(.center)
                Spacer()
                Divider()
                Spacer()
            }
            switchSubView()
        }
    }
}

struct PaymentRegistration_Previews: PreviewProvider {
    static var previews: some View {
        PaymentRegistration()
    }
}
