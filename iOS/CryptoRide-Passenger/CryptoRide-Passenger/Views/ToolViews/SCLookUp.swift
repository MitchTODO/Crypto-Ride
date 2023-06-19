//
//  SCLookUp.swift
//  CryptoRide-Passenger
//
//  Created by mitchell tucker on 6/14/23.
//

import SwiftUI

struct SCLookUp: View {
    // Bindings for parent view
    @Binding var showAttempts:Bool
    @Binding var blur:Int
    // PhoneNumber 
    @State var phoneNumber:String = ""
    // list Address linked to phone number
    @State var socialConnectAddress:[String]? = nil
    // Error and progess view
    @State var isLoading = false
    @State var error:Error? = nil
    
    var body: some View {
        VStack {
            Spacer()
            Text("Social Connect Lookup")
                .font(.title2)
                .bold()
            if error != nil {
                Text(error!.localizedDescription).font(.subheadline).bold()
            }
            HStack{
                TextField("Phone Number", text: $phoneNumber)
                    .onChange(of: phoneNumber) { n in
                    phoneNumber = phoneNumber.applyPatternOnNumbers(pattern: "+# ### ### ####", replacementCharacter: "#")
                }.padding(10)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
                .keyboardType(.numberPad)
                
                Button(action: {
                    // clear previous connections 
                    socialConnectAddress = nil
                    // set loading view 
                    isLoading = true
                    // Make request for number look up
                    WalletServices.shared.lookUpNumber(number: phoneNumber) { result in
                        isLoading = false
                        switch(result) {
                         // check success and set address list
                        case .success(let addressList):
                            self.socialConnectAddress = addressList
                        case .failure(let error):
                            // error handling 
                            self.error = error
                        }
                    }
                }, label: {
                    if isLoading {
                        ProgressView()
                    }else{
                        Image(systemName: "magnifyingglass")
                    }
                }).buttonStyle(.borderedProminent)
            }

            // show address results if not nil
            if socialConnectAddress != nil {
                VStack {
                    Text("Result")
                        .font(.headline)
                        .bold()
                    
                    if socialConnectAddress!.isEmpty {
                        Text("No record found.").font(.subheadline).bold()
                    }
                    ForEach(socialConnectAddress!,id: \.self) {
                        Text($0)
                            .font(.callout.bold())
                            .lineLimit(1)
                            .truncationMode(.middle)
                    }
                }
                .padding(2)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerSize:CGSize(width: 5, height: 5)))
            }
            Spacer()
            HStack{
                Spacer()
                Button(action: {
                    blur = 0
                    showAttempts = false
                }, label: {
                    Text("Dismiss")
                })
                Spacer()
            }
        }
        .padding(10)
        .textFieldStyle(.roundedBorder)
    }
}

struct SCLookUp_Previews: PreviewProvider {
    static var previews: some View {
        SCLookUp(showAttempts: .constant(true), blur: .constant(20))
    }
}

