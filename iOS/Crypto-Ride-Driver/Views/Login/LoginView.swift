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
            
            Button(action: {
                loginVM.login() { result in
                    authentication.updateAuthState(goto: result)
                }
            }, label: {
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
            })
            .buttonStyle(.borderless)
            .foregroundColor(.white)
            .background(.black)
            .cornerRadius(5)
            
            
            Spacer()
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
