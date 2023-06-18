//
//  WalletRecoveryView.swift
//  CryptoRide-Passenger
//
//  Created by mitchell tucker on 6/15/23.
//

import SwiftUI

struct WalletRecoveryView: View {
    
    @EnvironmentObject var loginViewModel:LoginViewModel
    @EnvironmentObject var authentication:Authentication
    
    @Binding var blur:Int
    
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Wallet Recovery").font(.title2)
            Text("Write down your recovery phase.")
                .font(.headline)
                .multilineTextAlignment(.center)
            Text("This will only be shown once!")
                .font(.headline)
                .multilineTextAlignment(.center)
            VStack(spacing: 10) {
                Divider()
                Text(loginViewModel.mnemonics)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .bold()
                Divider()
                
            }.padding(5)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerSize:CGSize(width: 5, height: 5)))
            Button(action: {
                loginViewModel.hasKeyStore = true // update keystore value
                
                loginViewModel.showMnemonic = false
                blur = 0
                authentication.updateValidation(success: true,password:loginViewModel.credentials.password)
                loginViewModel.showProgressView = false
            }, label: {
                Text("I understand")
            })
            Spacer()
        }
    }
}

struct WalletRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        WalletRecoveryView(blur: .constant(20))
    }
}


