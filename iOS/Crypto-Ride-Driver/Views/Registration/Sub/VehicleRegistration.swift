//
//  VehicleRegistration.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/7/23.
//

import SwiftUI

struct VehicleRegistrationView: View {
    
    @EnvironmentObject var registrationVM:RegisterViewModel
    
    @StateObject private var registerVM = RegisterViewModel()
    var body: some View {
        VStack{
            Text("Vehicle Profile").font(.title2)
            EditableCircularProfileImage( systemImage: "car")
                                    .environmentObject(registrationVM.profilePic)
                                    .onChange(of: registrationVM.profilePic.imageData, perform: { data in
                                        // Set image data to profile struct
                                        //registrationVM.registerNewDriver.profile.profileImageData = data
                                        print(data)
                                    })
                                                
            Section {
                TextField("Year",text: $registrationVM.registerNewDriver.vehicle.year).keyboardType(.default)
                TextField("Make",text: $registrationVM.registerNewDriver.vehicle.make).keyboardType(.default)
                TextField("Model",text: $registrationVM.registerNewDriver.vehicle.model).keyboardType(.default)
                TextField("Color",text: $registrationVM.registerNewDriver.vehicle.color).keyboardType(.default)
                Stepper("Passenger Count: \(registrationVM.registerNewDriver.vehicle.seatNumber)", value:  $registrationVM.registerNewDriver.vehicle.seatNumber, in: 2...6).bold()
                Spacer()
                Button(action: {
                    registrationVM.subview = .LocationProfile
                    registrationVM.selectedView = "mappin.and.ellipse"
                    registrationVM.buttonNumber += 1
                }, label: {
                    Spacer()
                    Text("Next").bold()
                    Spacer()
                }).buttonStyle(.borderedProminent)
            }.textFieldStyle(.roundedBorder)
                .disableAutocorrection(true)
                .padding(5)
            
        }
    }
}

struct VehicleRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleRegistrationView()
    }
}
