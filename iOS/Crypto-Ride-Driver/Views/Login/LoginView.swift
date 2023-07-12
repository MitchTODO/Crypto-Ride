//
//  ContentView.swift
//  Crypto-Ride-Driver
//
//  Created by mitchell tucker on 7/7/23.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginVM = LoginViewModel()
    @EnvironmentObject var authentication:Authentication
 
    var body: some View {
        VStack {
            Text("Crypto Ride").font(.custom("AtomicAge-Regular", size: 36))
            
            Spacer()
            HStack{
                Text("Welcome Driver")
                    .bold()
                    .font(.custom("AtomicAge-Regular", size: 25))
                Spacer()
            }
            
            HStack{
                if WalletServices.shared.hasKeyStore {
                    // Switch between faceId and Password
                    TextField("",text: $loginVM.credentials.password)
                        .disabled(loginVM.isloading)
                        .textFieldStyle(.roundedBorder)
                        .onTapGesture {
                            loginVM.error = nil
                        }
                        
                }
                if loginVM.isloading {
                    ProgressView().padding(10)
                }else{
                    Button(action: {
                        loginVM.login() { result in
                            authentication.updateAuthState(goto: result)
                        }
                    }, label: {
                        
                        // check if device has wallet under keystore
                        if WalletServices.shared.hasKeyStore {
                            Text("Login")
                                .font(.custom("AtomicAge-Regular", size: 15))
                                .padding(10)
                        }else{
                            Spacer()
                            Text("Sign Up")
                                .font(.custom("AtomicAge-Regular", size: 15))
                                .padding(10)
                            Spacer()
                            if loginVM.isloading {
                                ProgressView()
                                    .tint(.white)
                                    .padding(10)
                            } else{
                                Image(systemName:"arrowshape.right.fill")
                                    .padding(5)
                            }
                        }
                    })
                    .buttonStyle(.borderless)
                    .foregroundColor(Color("TextColor"))
                    .background(Color("ButtonColor"))
                    .cornerRadius(5)
                }

            }
            
            if loginVM.error != nil {
                Text("Password Failed")
                    .multilineTextAlignment(.leading)
                    .font(.headline)
            }
            
            Spacer()
            Text("Import")
                .font(.caption)
                .bold()
                .multilineTextAlignment(.center)
            VStack(){
                Divider()
                
                Text("Powered By")
                    .font(.custom("AtomicAge-Regular", size: 15))
                    .padding(1)
                
                Image("Celo-Workmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 30, alignment: .center)
                    .padding(1)
                
            }

        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
