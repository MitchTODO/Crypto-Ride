//
//  LocationRegistration.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/7/23.
//

import SwiftUI
import MapKit

struct LocationRegistration: View {
    
    @EnvironmentObject var registrationVM:RegisterViewModel
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var body: some View {
            VStack{
                Text("Location").font(.title2)
                Map(coordinateRegion: $region)
                    .frame(height: 350)
                    .cornerRadius(10)
                
                Text("Work Radius").font(.headline).bold()
                Stepper("Miles \(registrationVM.registerNewDriver.location.zone) ", value:  $registrationVM.registerNewDriver.location.zone, in: 1...100)
                
                Spacer()
                Divider().padding(10)
                Spacer()
                HStack {
                    TextField("City",text: $registrationVM.registerNewDriver.location.city).keyboardType(.default)
                    TextField("State",text: $registrationVM.registerNewDriver.location.state).keyboardType(.default)
                }.padding(10)
                
                Spacer()
                Button(action: {
                    registrationVM.subview = .PaymentProfile
                    registrationVM.selectedView = "dollarsign"
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

struct LocationRegistration_Previews: PreviewProvider {
    static var previews: some View {
        LocationRegistration()
    }
}
