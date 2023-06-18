//
//  ProfileRegistration.swift
//  CryptoRide-Driver
//
//  Created by mitchell tucker on 10/23/22.
//

import SwiftUI
import PhotosUI

struct ProfileRegistration: View {
    
    @EnvironmentObject var registrationVM:RegistrationViewModel
    
    @State private var profileItem:PhotosPickerItem?
    
    var body: some View {

    Section(header:Text("Profile")) {
            VStack{
                HStack {
                    Spacer()
                    EditableCircularProfileImage( systemImage: "person.crop.circle")
                        .environmentObject(registrationVM.profilePic)
                        .onChange(of: registrationVM.profilePic.imageData, perform: { data in
                            // Set image data to profile struct
                            registrationVM.registerNewDriver.profile.profileImageData = data
                        })
                    Spacer()
                }

                Section {
                    TextField("Name",text: $registrationVM.registerNewDriver.profile.name).keyboardType(.default)
                    VStack{
                
                        Text("Link with Social Connect").font(.caption)
                        TextField("Phone Number",text: $registrationVM.registerNewDriver.profile.phoneNumber)
                            .keyboardType(.phonePad)
                            .padding(0)
                            .onChange(of: registrationVM.registerNewDriver.profile.phoneNumber) { n in
                                registrationVM.registerNewDriver.profile.phoneNumber = registrationVM.registerNewDriver.profile.phoneNumber.applyPatternOnNumbers(pattern: "+# ### ### ####", replacementCharacter: "#")
                            }
                    }
                }
            }
            .textFieldStyle(.roundedBorder)
            .disableAutocorrection(true)
            .padding()
        }
    }
}

struct ProfileRegistration_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRegistration()
    }
}
