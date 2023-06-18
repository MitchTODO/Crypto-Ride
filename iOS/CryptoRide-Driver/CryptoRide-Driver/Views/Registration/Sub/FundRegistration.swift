//
//  FundRegistration.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 10/23/22.
//

import SwiftUI
import web3swift

struct FundRegistration: View {
    
    @EnvironmentObject var authentication:Authentication
    @EnvironmentObject var registrationVM:RegistrationViewModel
    
    @State var isLoading = false
    @State var isGenerating = false
    @State var showRecovery = false
    @State var blur = 5.0

    var body: some View {
        Section(header:Text("Wallet Recovery & Funding")) {
            VStack {
             Spacer()
                VStack {
                    Text("Your Wallet Password")
                        .font(.subheadline)
                        .bold()
                    
                    TextField("Password",text: $registrationVM.registerNewDriver.wallet.password)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        //.disabled(registrationVM.hasKeyStore) // cant edit password after gen
                    
                    TextField("Re-enter Password",text: $registrationVM.registerNewDriver.wallet.repassword)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(.roundedBorder)
                        //.disabled(registrationVM.hasKeyStore)
                    if !registrationVM.hasKeyStore {
                        Button(action: {
                            isGenerating = true
                            registrationVM.genKeyStore { mnemonic in
                                isGenerating = false // stop progress view
                                registrationVM.hasKeyStore = true // hide button
                                
                                registrationVM.getTokenBalance(.Celo)
                                registrationVM.getTokenBalance(.CUSD)
                            }
                        }, label: {
                            if isGenerating {
                                ProgressView() // show progress view when generating
                            }else{
                                Text("Generate")
                            }
                        }).buttonStyle(.borderedProminent)
                        .disabled(isGenerating)
                    }
                }
                Spacer()
                if  registrationVM.hasKeyStore {
                    if registrationVM.registerNewDriver.wallet.mnemonics == "" {
                        VStack {
                            Text("Write down your recovery phrase. This will only be shown once!")
                                .font(.subheadline)
                                .multilineTextAlignment(.center)
                                .bold()
                            Spacer()
                            Text(registrationVM.registerNewDriver.wallet.mnemonics)
                                .font(.footnote)
                                .multilineTextAlignment(.center)
                                .bold()
                            Spacer()
                        }
                    }
                    Divider()
                    VStack {
                        Text("Fund your wallet.")
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                            .bold()
                        WalletQRCodeView(address: WalletServices.shared.keystoreManager!.addresses!.first!.address, phone: "")
                        HStack {
                            HStack{
                                Image("cUSDEx")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30, alignment: .trailing)
                                
                                Text("\(registrationVM.cUSD)")
                            }
                            HStack{
                                Image("CeloEx")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30, alignment: .trailing)
                                
                                Text("\(registrationVM.CELO)")
                            }
                            
                            Divider()
                            Button {
                                registrationVM.getTokenBalance(.CUSD)
                                registrationVM.getTokenBalance(.Celo)
                            } label: {
                                if registrationVM.isBalanceLoading {
                                    ProgressView()
                                }else{
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .resizable()
                                        .interpolation(.none)
                                        .scaledToFit()
                                        .frame(width: 20, height: 20, alignment: .center)
                                }
                            }.buttonStyle(.borderless)
                        }
                        //Divider()
                        //Spacer()
                        /*
                        VStack{
                            Text("Register Soul Name").font(.body.bold())
                            
                            TextField("masa.celo",text: $registrationVM.registerNewDriver.profile.soulName)
                                .multilineTextAlignment(.center)
                                .textFieldStyle(.roundedBorder)
                            
                            if registrationVM.nameAvaiable != registrationVM.registerNewDriver.profile.soulName {
                                Button(action: {
                            
                                    registrationVM.checkSoulNameAvaibility(name: registrationVM.registerNewDriver.profile.soulName)
                                }, label: {
                                    Text("Check Avaiablity")
                                }).buttonStyle(.borderedProminent)
                            }
                            if registrationVM.avaibility {
                                Image(systemName: "checkmark.circle")
                            }
                            
                        }
                        */
                    }
                }
            }
        }
    }
}

struct FundRegistration_Previews: PreviewProvider {
    static var previews: some View {
        FundRegistration()
    }
}
