//
//  Registration.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 10/30/22.
//

import SwiftUI

struct Registration: View {
    
    @EnvironmentObject var registered:Registered
    @EnvironmentObject var manager:LocationManager
    @EnvironmentObject var driver:Driver
    @EnvironmentObject var balance:Balance
    
    var body: some View {
            Spacer()
            VStack(alignment: .center) {
                Text("Driver Registration")
                    .font(.title3)
                    .bold()
                    .padding(10)
                
                Text("You must setup & register your profile before accepting passengers.")
                    .font(.body)
                    .padding(2)
                    .multilineTextAlignment(.center)
                
                HStack {
                    // Sense we are navigating from this view driver is not registered
                    NavigationLink(destination: ProfileView().environmentObject(registered)
                        .environmentObject(driver)
                        .environmentObject(balance)
                    ){
                        Image(systemName: "person.crop.circle")
                        Text("Register")
                    }.padding()
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerSize:CGSize(width: 15, height: 15)))
            .padding(5)
            Spacer()
        }
}

struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        Registration()
    }
}
