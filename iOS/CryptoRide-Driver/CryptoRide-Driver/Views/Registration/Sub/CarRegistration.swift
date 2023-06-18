//
//  CarRegistration.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 10/23/22.
//

import SwiftUI
import PhotosUI

struct CarRegistration: View {
    
    @EnvironmentObject var registrationVM:RegistrationViewModel
    @State private var vehicleItem:PhotosPickerItem?
    
    var body: some View {
            Section(header:Text("Vehicle")) {
                VStack {
                    HStack {
                        Spacer()
                        EditableCircularProfileImage( systemImage: "car")
                            .environmentObject(registrationVM.vehiclePic)
                            .onChange(of: registrationVM.vehiclePic.imageData, perform: { data in
                            // Set image data to vehicle struct
                            registrationVM.registerNewDriver.vehicle.vehicleImageData = data
                        })
                        Spacer()
                    }
                    
                    Section {
                        TextField("Year",text: $registrationVM.registerNewDriver.vehicle.year).keyboardType(.default)
                        TextField("Make Model",text: $registrationVM.registerNewDriver.vehicle.makeModel).keyboardType(.default)
                        TextField("Color",text: $registrationVM.registerNewDriver.vehicle.color).keyboardType(.default)
                        HStack {
                            Text("Max Passengers \(registrationVM.registerNewDriver.vehicle.seatNumber)").font(.headline).bold()
                            Stepper("", value:  $registrationVM.registerNewDriver.vehicle.seatNumber, in: 2...6)
                        }
                    }
                    Spacer()
                }.textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .padding()
            }
        
    }
}

struct CarRegistration_Previews: PreviewProvider {
    static var previews: some View {
        CarRegistration()
    }
}
