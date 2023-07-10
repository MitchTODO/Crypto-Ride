//
//  RegisterView.swift
//  Crypto-Ride
//
//  Created by mitchell tucker on 7/7/23.
//

import SwiftUI

struct RegisterView: View {
    
    @StateObject private var registerVM = RegisterViewModel()
    
    private let buttons = ["person.fill", "car.fill", "mappin.and.ellipse", "dollarsign","paperplane.fill"]
    
    func switchSubView() -> AnyView {
        switch(registerVM.subview) {
            case .DriverProfile:
                
                return AnyView(
                    DriverRegistrationView().environmentObject(registerVM)
                )
            
            case .VehicleProfile:

                return AnyView(
                    VehicleRegistrationView().environmentObject(registerVM)
                )
            
            case .LocationProfile:
                return AnyView(
                    LocationRegistration().environmentObject(registerVM)
                )
            
            case .PaymentProfile:
                return AnyView(
                    PaymentRegistration().environmentObject(registerVM)
                )
            
            case .OverView:
                return AnyView (
                    RegOverView().environmentObject(registerVM)
                )
        }
    }

    
    func handleButton(image:String) {
        switch(image) {
            case "person.fill":
                registerVM.subview = .DriverProfile
            case "car.fill":
                registerVM.subview = .VehicleProfile
            case "mappin.and.ellipse":
                registerVM.subview = .LocationProfile
            case "dollarsign":
                registerVM.subview = .PaymentProfile
            case "paperplane.fill":
                registerVM.subview = .OverView
            default:
                return
        }
    }
    
    func selected(image:String) -> CGFloat {
        if image == registerVM.selectedView {
            return 10.0
        }else {
            return 3.0
        }
    }
    
    func isDisabled(image:String) -> Bool {
        let index = buttons.firstIndex(of: image)
        if registerVM.buttonNumber <= index! {
            return true
        }
        return false
    }
    
    
    var body: some View {
            VStack {
                HStack {
                    ForEach(buttons, id: \.self) { systemImage in
                        Button(action: {
                            handleButton(image: systemImage)
                            registerVM.selectedView = systemImage
                        }, label: {
                            VStack{
                                Image(systemName: systemImage).frame(width: 10,height: 10)
                                Divider()
                                    .frame(minHeight: selected(image: systemImage))
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    
                                    
                            }
                        }).padding()
                            .disabled(isDisabled(image: systemImage))
                        
                     }
                }
                ScrollView{
                    switchSubView()
                }
            }
            .padding()
        
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
