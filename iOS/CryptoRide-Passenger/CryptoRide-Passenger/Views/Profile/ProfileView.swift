//
//  ProfileView.swift
//  CryptoRide-Passenger
//
//  Created by mitchell tucker on 10/17/22.
//

import SwiftUI
import CodeScanner
import web3swift

struct ProfileView:View {
    // Init profile view model
    @StateObject var profileVM = ProfileViewModel()
    @EnvironmentObject var balance:Balance
    @EnvironmentObject var reputation:Reputation
    
    @State private var isShowingScanner = false
    @State var isTransfer = false
    
    // Social Connect
    @State var usingPhoneNumber = false
    @State var isLookUp = false
    @State var lookupAddress = ""
    @State var error:Error? = nil
    
    // Transferable tokens
    var tokens = ["cUSD","CELO"]
    
    var body: some View {
        ScrollView {
        VStack(alignment: .center) {
            VStack{

                    Text("Rating ")
                    RatingView(rating:reputation.rating)
               
                    Text("Reputation")
                    Text(reputation.reputation)
                
                    Text("Total Rides")
                    Text(reputation.rideCount)
                
                }
                HStack{
                    HStack{
                        Image("cUSDEx")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 30, alignment: .center)
                        Text("\(balance.cUSD)")
                        
                    }
                    Divider()
                    HStack{
                        Image("CeloEx")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20, alignment: .center)
                        Text("\(balance.CELO)")
                        
                    }
                    Button{
                        balance.getTokenBalance(.CELO)
                        balance.getTokenBalance(.cUSD)
                        reputation.getReputation()
                    }label: {
                        Image(systemName: "arrow.clockwise.circle.fill")
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 20, height: 20, alignment: .center)
                    }.buttonStyle(.borderless)
                    
                }.padding()
                
            Divider()
            VStack(alignment: .center){
                HStack{
                    Spacer()
                    Text("Phone Number or Address").font(.footnote).multilineTextAlignment(.leading)
                    Spacer()
                }
                HStack {
                    Text("To").font(.title3)
                    TextField("", text: $profileVM.toAddress).onChange(of: profileVM.toAddress) { n in
                        if n.first == "0" {
                            // must be address
                            usingPhoneNumber = false
                        } else {
                            usingPhoneNumber = true
                            profileVM.toAddress = profileVM.toAddress.applyPatternOnNumbers(pattern: "+# ### ### ####", replacementCharacter: "#")
                        }
                    }
                    if usingPhoneNumber {
                        Button(action: {
                            isLookUp = true
                            lookupAddress = ""
                            // look up phone number
                            WalletServices.shared.lookUpNumber(number: profileVM.toAddress) { result in
                                isLookUp = false
                                switch(result) {
                                    
                                case .success(let addressList):
                                    if addressList.isEmpty {
                                        lookupAddress = "No Social Connect Record Found"
                                    }else{
                                        lookupAddress = addressList.first!
                                    }
                                case .failure(let error):
                                    self.error = error
                                }
                            }
                        }, label: {
                            // show progress view
                            if isLookUp {
                                ProgressView()
                            }else{
                                Image(systemName: "magnifyingglass.circle")
                            }
                        }).disabled(isLookUp)
                    }else{
                        Button(action:{
                            profileVM.toAddress = UIPasteboard.general.string ?? ""
                        }, label: {
                            Image(systemName: "doc.on.clipboard")
                        })
                    }
                }
                if usingPhoneNumber {
                    HStack{
                        Spacer()
                        Text(lookupAddress).font(.footnote)
                        Spacer()
                    }
                }
                
                HStack{
                    
                    Picker("", selection: $profileVM.tokenSelected) {
                        ForEach(tokens, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    TextField("0", text:  $profileVM.amount)
                    Button(action:{
                        if profileVM.tokenSelected == "cUSD" {
                            profileVM.amount = balance.cUSD
                        }else{
                            profileVM.amount = balance.CELO
                        }
                        
                    }, label: {
                        Text("MAX")
                    })
                }
                
                TextField("Wallet Password", text: $profileVM.password)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                if isTransfer{
                    ProgressView()
                }
                Button(action:{
                    isTransfer = true
                    profileVM.transfer(){ success in
                        // Get request for token balance
                        balance.getTokenBalance(.cUSD)
                        balance.getTokenBalance(.CELO)
                        // Clear all inputs
                        profileVM.amount = ""
                        profileVM.toAddress = ""
                        profileVM.password = ""
                        isTransfer = false
                    }
                }, label: {
                    Text("Send")
                }).disabled(profileVM.toAddress.isEmpty || profileVM.amount.isEmpty || isTransfer )
                
            }
            
            Divider()
            Text("Receive").font(.title3)
            
            WalletQRCodeView(address: ContractServices.shared.getWallet().address, phone: profileVM.userPhoneNumber)
            // Part of the qr code Scanner currently not used
        }.alert(item:$profileVM.error) { error in
            Alert(title: Text(profileVM.error!.title), message: Text(profileVM.error!.description), dismissButton: .cancel() {
                    profileVM.error = nil
                    profileVM.amount = ""
                    profileVM.toAddress = ""
                    profileVM.password = ""
                    isTransfer = false
                })
        }
        
        
        .sheet(isPresented: $isShowingScanner) {
            CodeScannerView(codeTypes: [.qr] ) { response in
                isShowingScanner = false
                switch response {
                case .success(let result):
                    // If qr was read successful try to separate ethereum string from qr
                    // Note there is no standard for reading qr codes, this is using MetaMask format
                    let ethereumAddress = result.string.components(separatedBy: "ethereum:")
                    if ethereumAddress.isEmpty {return}
                    guard let toEthAddress = EthereumAddress(ethereumAddress[1]) else {
                        return
                    }
                    
                    //profileVM.txParams.to = toEthAddress.address
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }.textFieldStyle(.roundedBorder)
            .padding(EdgeInsets(top: 8, leading: 16,
                                   bottom: 8, trailing: 16))
            .buttonStyle(.borderedProminent)
        }
    }
}

