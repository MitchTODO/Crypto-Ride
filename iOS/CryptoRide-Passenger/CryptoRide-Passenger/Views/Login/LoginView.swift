//
//  LoginView.swift
//  CryptoRide-Passenger
//
//  Created by mitchell tucker on 10/28/22.
//

import SwiftUI
// 4+ 555 444 5555
// 4+ 555 444 5556
// MARK: LoginView
struct LoginView: View {

    @StateObject private var loginVM = LoginViewModel()
    @EnvironmentObject var authentication:Authentication
    
    // Attempts
    @State private var attempts = 0
    @State private var showAttempts = false
    
    @State private var blur = 0
    
    @State private var animateGradient = false
    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(colors: [Color("PrimaryGreen"), Color("CeloGold")], startPoint: animateGradient ? .topLeading : .bottomLeading, endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            .edgesIgnoringSafeArea(.all)
        

            VStack(alignment: .center) {
                HStack {
                    Text("CryptoRide").font(.title).bold().padding()
                    Spacer()
                }
                
                HStack {
                    Text("Passenger").font(.title3).bold().padding()
                    Spacer()
                }
                
                VStack{
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
                    if !loginVM.hasKeyStore {
                        Text("Register Phone Number With Social Connect.").font(.caption2).bold()
                        TextField("+", text:$loginVM.credentials.phoneNumber)
                            .onChange(of: loginVM.credentials.phoneNumber) { n in
                                loginVM.credentials.phoneNumber = loginVM.credentials.phoneNumber.applyPatternOnNumbers(pattern: "+# ### ### ####", replacementCharacter: "#")
                        }.keyboardType(.phonePad)
                    }
                    
                    SecureField(loginVM.hasKeyStore ? "Password" : "New Password ", text: $loginVM.credentials.password)
                        .keyboardType(.asciiCapable)
                        .disabled(loginVM.showProgressView)
                    Button {
                        loginVM.showProgressView = true
                        loginVM.login { success in
                            if !success {
                                attempts += 1
                            }
                            if loginVM.showMnemonic {
                                blur = 20
                            } else {
                                // update validation
                                authentication.updateValidation(success: success,password:loginVM.credentials.password)
                                loginVM.showProgressView = false
                            }
                        }
                    }label: {
                        Spacer()
                        Text(loginVM.hasKeyStore ? "Login" : "Create Account")
                            .bold()
                            .font(.subheadline)
                        Spacer()
                        if loginVM.showProgressView {
                            ProgressView()
                                .tint(.black)
                        }else{
                            Image(systemName:"arrowshape.right.fill")
                        }
                    }.buttonStyle(.borderedProminent)
                        .disabled(loginVM.showProgressView)
                    .tint(.black)
                        

                }
                VStack{
                    Spacer()
                    Text("Powered By").font(.subheadline).bold().lineLimit(2)
                    Image("CeloLight")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 30, alignment: .center)
                }
            }
            .blur(radius: CGFloat(blur))
            .textFieldStyle(.roundedBorder)
            .padding(20)
            
            if loginVM.showMnemonic {
                WalletRecoveryView(blur: $blur)
                    .environmentObject(loginVM)
                    .environmentObject(authentication)
                    .padding(20)
            }
  
            if showAttempts {
                SCLookUp(showAttempts: $showAttempts, blur: $blur)
                    .padding(20)
            }

        }.textFieldStyle(.roundedBorder)
            .buttonStyle(.borderedProminent)
        
        .navigationTitle("Crypto Passenger")
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
