//
//  LocationRegistration.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 11/8/22.
//

import SwiftUI

struct LocationRegistration: View {
    //@EnvironmentObject var driver:Driver

    var body: some View {
        Section(header:Text("Location")) {
            VStack{
                Text("Selected On Map")
                Spacer()
            }.textFieldStyle(.roundedBorder)
             .disableAutocorrection(true)
             .padding()
        }
    }
}

struct LocationRegistration_Previews: PreviewProvider {
    static var previews: some View {
        LocationRegistration()
    }
}
