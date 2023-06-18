//
//  LoginViewV3.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 6/11/23.
//

import SwiftUI

struct LoginView: View {
    @State var credentials = Credentials()
    
    @StateObject private var loginVM = LoginViewModel()
    
    @EnvironmentObject var appState:AppState
    @EnvironmentObject var authentication:Authentication
    
    @State private var animateGradient = false
    @State private var isLoading = false
    
    // Attempts
    @State private var attempts = 0
    @State private var showAttempts = false
    @State private var blur = 0
    
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                LinearGradient(colors: [Color("PrimaryGreen"), Color("CeloGold")], startPoint: animateGradient ? .topLeading : .bottomLeading, endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                    .ignoresSafeArea()
                    .onAppear {
                        withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: true)) {
                            animateGradient.toggle()
                        }
                }
                .edgesIgnoringSafeArea(.all)
 
                VStack{
                    HStack {
                        Text("CryptoRide").font(.title).bold().padding()
                        Spacer()
                    }
                    
                    HStack {
                        Text("Driver").font(.title3).bold().padding()
                        Spacer()
                    }
                    VStack {
                            Spacer()
                            if attempts >= 2 {
                                Button(action: {
                                    blur = 20
                                    showAttempts.toggle()
                                }, label: {
                                    HStack {
                                        Text("Having Trouble?")
                                    }
                                }).buttonStyle(.borderless)
                            }
                            // Show loginVM is we have keystore
                            if loginVM.hasKeyStore {
                                SecureField("Password",text: $loginVM.credentials.password)
                                    .keyboardType(.asciiCapable)
                                    .disabled(isLoading)
                            }
                            Button(action: {
                                isLoading = true
                                // check if we have key store
                                if !loginVM.hasKeyStore {
                                    appState.updateValidation(state: .register)
                                } else {
                                    if loginVM.credentials.password.isEmpty {
                                        isLoading = false
                                        return
                                    }
                                    loginVM.login() { success in
                                        isLoading = false
                                        if success {
                                            authentication.password = loginVM.credentials.password
                                            appState.updateValidation(state: .login)
                                        } else {
                                            // keep incrementing attempts
                                            attempts += 1
                                        }
                                    }
                                }
                            }, label: {
                                Spacer()
                                Text(loginVM.hasKeyStore ? "Login" : "Create Account")
                                    .bold()
                                    .font(.subheadline)
                                Spacer()
                                if isLoading {
                                    ProgressView()
                                        .tint(.black)
                                }else{
                                    Image(systemName:"arrowshape.right.fill")
                                }
                            })
                            .buttonStyle(.borderedProminent)
                            .disabled(isLoading)
                            .tint(.black)
                            
                        }
                        
                    VStack {
                        Spacer()
                        Text("Powered By").font(.subheadline).bold().lineLimit(2)
                        Image("Celo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 30, alignment: .center)
                    }
                }
                .blur(radius: CGFloat(blur))
                .textFieldStyle(.roundedBorder)
                .padding(20)
                if showAttempts {
                    SCLookUp(showAttempts: $showAttempts, blur: $blur)
                        .padding(20)
                }
            }
        }
    }
}

struct LoginViewV3_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
