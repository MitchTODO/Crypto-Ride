//
//  registrationView.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 6/8/23.
//

import SwiftUI

struct RegistrationView: View {
    
    enum SectionState {
        case none
        case inProgress
        case done
    }
    
    @EnvironmentObject var authentication:Authentication
    @EnvironmentObject var registered:Registered
    @EnvironmentObject var appState:AppState
    
    @StateObject var registrationVM = RegistrationViewModel()
    var regViews:[Any] = [ProfileRegistration.self,CarRegistration.self,RateRegistration.self,FundRegistration.self]
    
    var textString:[String] = ["Vehicle", "Payment", "Wallet","Register"]
    
    @State var currentStep:Int = 1
    @State var isSending = false
    
    @State var imageUploading:SectionState = .none
    @State var registeredUploading:SectionState = .none
    @State var socialConnectUploading:SectionState = .none
    
    func readyToSend() -> Bool {
        if currentStep < regViews.count {return false} // show registerView
        if registrationVM.registerNewDriver.profile.name.isEmpty {return true}
        if registrationVM.registerNewDriver.profile.phoneNumber.isEmpty {return true}
        if registrationVM.registerNewDriver.vehicle.year.isEmpty {return true}
        if registrationVM.registerNewDriver.vehicle.makeModel.isEmpty {return true}
        if registrationVM.registerNewDriver.vehicle.color.isEmpty {return true}
        if !registrationVM.hasKeyStore {return true} // no keystore
        //if registrationVM.cUSD == "0" {return true} // cant register on zero balance
        return false
    }
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(0..<currentStep,id:\.self) { index in
                    self.buildView(types: self.regViews, index: index)
                }
                if isSending {
                    HStack {
                        Text("Uploading Images to IPFS.")
                        Spacer()
                        if imageUploading == .inProgress {
                            ProgressView()
                        }else if imageUploading == .done{
                            Image(systemName: "checkmark.circle")
                        }
                    }
                    HStack {
                        Text("Registering with Smart Contract.")
                        Spacer()
                        if registeredUploading == .inProgress {
                            ProgressView()
                        }else if registeredUploading == .done{
                            Image(systemName: "checkmark.circle")
                        }
                    }
                    HStack {
                        Text("Register with Social Connect.")
                        Spacer()
                        if socialConnectUploading == .inProgress {
                            ProgressView()
                        }else if socialConnectUploading == .done{
                            Image(systemName: "checkmark.circle")
                        }
                        
                    }
                }else {
                    Button(action: {
                        // Check if end of regsiter sub views
                        if currentStep < regViews.count {
                            currentStep += 1
                        } else {
                            // send registration request
                            isSending = true
                            let car = registrationVM.registerNewDriver.vehicle.year
                            + " " +
                            registrationVM.registerNewDriver.vehicle.color
                            + " " +
                            registrationVM.registerNewDriver.vehicle.makeModel
                            
                            let vehicleId = UUID()
                            let profileId = UUID()
                            
                            imageUploading = .inProgress
                            
                            // Three step registration process
                            // Upload images to ipfs (NOT USED)
                            // Profile picture
                            //registrationVM.uploadImage(paramName: "image", fileName: profileId.description, image: UIImage(data: registrationVM.vehiclePic.imageData!)!) { vehicleCID in
                                // Vehicle picture
                                //registrationVM.uploadImage(paramName: "image", fileName: vehicleId.description, image: UIImage(data: registrationVM.profilePic.imageData!)!) { profileCID in
                                    imageUploading = .done
                                    
                                    // Start progressView for contract registeration
                                    registeredUploading = .inProgress
                                    
                                    // Register driver with contract
                                    registrationVM.registerDriver(
                                        rate: registrationVM.registerNewDriver.rate.fare,
                                        name: registrationVM.registerNewDriver.profile.name + " " + "",
                                        car: car + " " + ""
                                        ) { registered in
                                            
                                            // start progressView for social connect
                                            registeredUploading = .done
                                            socialConnectUploading = .inProgress
                                            
                                            // Register social connect
                                            registrationVM.registerSocialConnect(phone: registrationVM.registerNewDriver.profile.phoneNumber) { socialResult in
                                                socialConnectUploading = .done
                                                // Set user defaults for phone number
                                                let defaults = UserDefaults.standard
                                                defaults.set(registrationVM.registerNewDriver.profile.phoneNumber, forKey: "phoneNumber")
                                                appState.updateValidation(state: .login)
                                                // set password for ride handling
                                                authentication.password = registrationVM.registerNewDriver.wallet.password
                                            }
                                        }
                                //}
                            //}
                            
                        }
                    }, label: {
                        HStack {
                            Spacer()
                            if currentStep >= regViews.count {
                                Text(textString[currentStep - 1])
                                Image(systemName: "paperplane")
                            }else{
                                Text(textString[currentStep - 1])
                                Image(systemName: "chevron.down")
                            }
                            Spacer()
                        }
                    }).buttonStyle(.borderless)
                        .disabled(readyToSend())
                }
            }.navigationTitle("Account Creation")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            //webSocket.disconnectSocket()
                            //manager.deleteDB()
                            appState.updateValidation(state: .logout)
                            //authentication.updateValidation(success: false, phoneNumber: "", password: "", mnemonic: "")
                        }
                    }
                }
        }
    }
    
    func buildView(types: [Any], index: Int) -> AnyView {
        switch types[index].self {
            case is ProfileRegistration.Type: return AnyView(ProfileRegistration().environmentObject(registrationVM))
            case is CarRegistration.Type: return AnyView(CarRegistration().environmentObject(registrationVM))
            //case is LocationRegistration.Type: return AnyView(LocationRegistration())
            case is RateRegistration.Type: return AnyView(RateRegistration().environmentObject(registrationVM))
            case is FundRegistration.Type: return AnyView(FundRegistration().environmentObject(registrationVM))
            default: return AnyView(EmptyView())
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
