//
//  RateRegistration.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 10/23/22.
//

import SwiftUI

// NOTE Currently not used
struct RateRegistration: View {
    
    @EnvironmentObject var registrationVM:RegistrationViewModel
    
    var body: some View {
        Section(header:Text("Payment & Hourly Rate")) {
            VStack {
                Text("Changing your hourly rate will be available in settings.").font(.subheadline)
                HStack {
                    Text("$ \(registrationVM.registerNewDriver.rate.fare)").font(.title2).bold()
                    Stepper("per hour", value:  $registrationVM.registerNewDriver.rate.fare, in: 18...100)
                }
                Spacer()
            }.textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .padding()
        }
    }
}

struct RateRegistration_Previews: PreviewProvider {
    static var previews: some View {
        RateRegistration()
    }
}
