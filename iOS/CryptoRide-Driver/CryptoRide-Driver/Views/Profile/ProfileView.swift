//
//  ProfileView.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 10/21/22.
//

import SwiftUI

// View states for registration
enum setView{
    case profile
    case car
    case location
    case rate
    case fund
}

struct ProfileView: View {
    // EnvironmentObject
    @EnvironmentObject var registered:Registered
    @EnvironmentObject var balance:Balance
    @EnvironmentObject var driver:Driver
    @EnvironmentObject var manager:LocationManager
    
    // State objects
    @StateObject var profileVM = ProfileViewModel()
    
    @State var isLoading = false
    @State var isTransfer = false
    
    // Social Connect
    @State var isLookUp = false
    
    @State var error:Error? = nil
    
    // Selectable tokens
    var tokens = ["cUSD","CELO"]
    var formList:[AnyView] = []
    
    var body: some View {
        VStack{
            Spacer()
            if profileVM.driverInfo != nil {
                ScrollView {
                    VStack(alignment:.center){
                        VStack {
                            VStack(spacing:8){
                                CircularProfileImageDL(systemImage: "person.crop.circle")
                                    .environmentObject(driver.profilePic)
                               
                                
                                Text(driver.name).font(.title)
                                CircularProfileImageDL(systemImage: "car")
                                    .environmentObject(driver.vehiclePic)
                               
                                Text(driver.car).font(.title3)
                                Text("Rating ")
                                RatingView(rating:$driver.rating)
                                
                                Text("Reputation")
                                Text(driver.reputation)
                                
                                Text("Total Rides")
                                Text(driver.rideCount)
                                
                            }.padding()
                            HStack{
                                HStack{
                                    Image("cUSDEx")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30, alignment: .trailing)
                                    Text("\(balance.cUSD)")
                                }
                                HStack{
                                    Image("CeloEx")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20, alignment: .trailing)
                                    Text("\(balance.CELO)")
                                }
                                Divider()
                                Button {
                                    balance.getTokenBalance(.CUSD)
                                    balance.getTokenBalance(.Celo)
                                    driver.getReputation()
                                }label: {
                                    Image(systemName: "arrow.clockwise.circle.fill")
                                        .resizable()
                                        .interpolation(.none)
                                        .scaledToFit()
                                        .frame(width: 20, height: 20, alignment: .center)
                                }.buttonStyle(.borderless)
                            }
                        }
                        Divider()
                        VStack(alignment: .leading) {
                            HStack {
                                Spacer()
                                Text("Phone Number Or Address").font(.footnote).multilineTextAlignment(.leading)
                                Spacer()
                            }
                            HStack {
                                Text("To").font(.title3)
                                TextField("", text: $profileVM.toAddress).onChange(of: profileVM.toAddress) { n in
                                    if n.first == "0" {
                                        // must be address
                                        profileVM.usingPhoneNumber = false
                                    } else {
                                        profileVM.usingPhoneNumber = true
                                        profileVM.toAddress = profileVM.toAddress.applyPatternOnNumbers(pattern: "+# ### ### ####", replacementCharacter: "#")
                                    }
                                }
                                if profileVM.usingPhoneNumber {
                                    Button(action: {
                                        isLookUp = true
                                        profileVM.lookupAddress = ""
                                        
                                        // look up phone number
                                        WalletServices.shared.lookUpNumber(number: profileVM.toAddress) { result in
                                            isLookUp = false
                                            switch(result) {
                                            case .success(let addressList):
                                                if addressList.isEmpty {
                                                    profileVM.lookupAddress = "No Social Connect Record Found"
                                                }else{
                                                    profileVM.lookupAddress = addressList.first!
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
                            
                            if profileVM.usingPhoneNumber {
                                HStack{
                                    Spacer()
                                    Text(profileVM.lookupAddress).font(.footnote)
                                    Spacer()
                                }
                            }
                            
                            HStack {
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
                            HStack{
                                Spacer()
                                Button(action: {
                                    isTransfer = true
                                    profileVM.transfer() { success in
                                        // Get request for token balance
                                        balance.getTokenBalance(.CUSD)
                                        balance.getTokenBalance(.Celo)
                                        // Clear all inputs
                                        profileVM.amount = ""
                                        profileVM.toAddress = ""
                                        profileVM.password = ""
                                        profileVM.lookupAddress = ""
                                        isTransfer = false
                                    }
                                }, label: {
                                    if isTransfer {
                                        ProgressView()
                                    }else{
                                        Text("Send")
                                    }
                                    
                                }).disabled(profileVM.toAddress.isEmpty || profileVM.amount.isEmpty || isTransfer)
                                Spacer()
                            }
                        }
                        Divider()
                        Text("Receive").font(.title3)
                        WalletQRCodeView(address: ContractServices.shared.getWallet().address, phone: profileVM.userPhoneNumber)
                    }.textFieldStyle(.roundedBorder)
                        .padding(EdgeInsets(top: 8, leading: 16,
                                            bottom: 8, trailing: 16))
                        .buttonStyle(.borderedProminent)
                }
            }else{
                ProgressView()
            }
        
        }.alert(item:$profileVM.error) { error in
            Alert(title: Text(profileVM.error!.title), message: Text(profileVM.error!.description), dismissButton: .cancel() {
                profileVM.error = nil
                profileVM.amount = ""
                profileVM.toAddress = ""
                profileVM.password = ""
                isTransfer = false
            })
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: Settings().environmentObject(registered)
                    .environmentObject(balance)
                    .environmentObject(driver)
                    .environmentObject(profileVM)
                ){
                    Image(systemName: "gear")
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
