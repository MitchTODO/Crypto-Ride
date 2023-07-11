//
//  ProfileRegistration.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/7/23.
//

import SwiftUI
import PhotosUI

struct DriverRegistrationView: View {
    
    @EnvironmentObject var registrationVM:RegisterViewModel
    @State private var profileImage:PhotosPickerItem?
    @State private var selectedHandle = "twitter"
    let handles = ["twitter"]
    
    var body: some View {

            VStack{
                Text("Driver Profile").font(.title3).bold()
                EditableCircularProfileImage( systemImage: "person.crop.circle")
                    .environmentObject(registrationVM.profilePic)
                    .onChange(of: registrationVM.profilePic.imageData, perform: { data in
                        // Set image data to profile struct
                        //registrationVM.registerNewDriver.profile.profileImageData = data
                        print(data)
                    })
                
                Section {
                    TextField("Full Name",text: $registrationVM.registerNewDriver.profile.name).keyboardType(.default)
                    TextField("Phone Number",text: $registrationVM.registerNewDriver.profile.phoneNumber)
                        .keyboardType(.phonePad)
                        .padding(0)
                        .onChange(of: registrationVM.registerNewDriver.profile.phoneNumber) { n in
                            registrationVM.registerNewDriver.profile.phoneNumber = registrationVM.registerNewDriver.profile.phoneNumber.applyPatternOnNumbers(pattern: "+# ### ### ####", replacementCharacter: "#")
                        }
                    HStack{
                        TextField("Social Handle",text: $registrationVM.registerNewDriver.profile.socialHandle)
                        Menu(content: {
                            Picker("", selection: $selectedHandle) {
                                ForEach(handles, id: \.self) {
                                    Image($0).resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30, alignment: .center)
                                        .padding(1)
                                }
                            }
                        }, label: {
                            Image(selectedHandle).resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30, alignment: .center)
                                .padding(1)
                        })
                    }
                    VStack{
                        HStack{
                            TextField("Soul Name",text: $registrationVM.registerNewDriver.profile.soulName).padding(0)
                            Button(action: {
                                
                            }, label: {
                                Image(systemName: "info.circle.fill")
                                    .scaledToFit()
                                    .frame(width: 30, height: 30, alignment: .center)
                                    .padding(1)
                            })
                            Spacer()
                        }
                        .padding(0)
                    }
                    Spacer()
                    Button(action: {
                        registrationVM.subview = .VehicleProfile
                        registrationVM.selectedView = "car.fill"
                        registrationVM.buttonNumber += 1
                    }, label: {
                        Spacer()
                        Text("Next")
                            .bold()
                            

                        Spacer()
                    }).buttonStyle(.borderedProminent)
                        //.buttonStyle(.borderless)
                        //.foregroundColor(.white)
                        //.background(.black)
                        //.cornerRadius(5)
                    
                    
                }.textFieldStyle(.roundedBorder)
                    .disableAutocorrection(true)
                    .padding(5)
        }
    }
}

struct DriverRegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        DriverRegistrationView()
    }
}

