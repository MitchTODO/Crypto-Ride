//
//  SelectDrivers.swift
//  CryptoRide-Passenger
//
//  Created by mitchell tucker on 9/15/22.
//

import Foundation
import SwiftUI



struct SelectDrivers:View {

    @EnvironmentObject var manager:LocationManager
    @EnvironmentObject var builderVm:MainBuilderViewModel

    
    var body: some View {
        VStack{
            if(manager.selectedDriver != nil) {
                VStack{
                    HStack{
                        Button{
                            manager.selectedDriver = nil
                            manager.selectedAnnotation = nil
                        }label: {
                            Image(systemName:"xmark.square.fill").padding(10)
                        }.buttonStyle(.bordered)
                        Spacer()
                        Text("Driver").font(.title2)
                        
                    }
                    
                    VStack(alignment: .center,spacing: 10.0){
                        if(manager.selectedDriver != nil){
                            HStack {
                                CircularProfileImageDL(systemImage: "person")
                                    .environmentObject(manager.profilePic)
                                Text(manager.selectedDriver!.info!.infoAssetLink!).font(.title2).bold()
                            }
                            HStack{
                                CircularProfileImageDL(systemImage: "car")
                                    .environmentObject(manager.vehiclePic)
                                Text(manager.selectedDriver!.info!.carAssetLink!).font(.title3).bold()
                            }
                            

                            Divider()
                            RatingView(rating: manager.selectedDriver!.stats!.rating!, disabled: true)
                            
                            Text("Reputation \(manager.selectedDriver!.stats!.reputation!.description)").font(.subheadline).bold()
                            Text("Total Rides \(manager.selectedDriver!.stats!.count!.description)").font(.subheadline).bold()
                        }else{
                            ProgressView()
                        }
                       
                    }
                    
                    
                 
                }.background(.bar)
                    .cornerRadius(15)
                    .padding(5)
    
                Spacer()
                
            }
            Spacer()
                HStack{
                    Button(action:{
                        // Deselect driver and selected annotation
                        manager.selectedDriver = nil
                        manager.selectedAnnotation = nil
                        
                        builderVm.builderStates = .rideLocation
                    } , label: {
                        Image(systemName: "chevron.left")
                    }).padding()
                    .buttonStyle(.borderedProminent)
                    Spacer()
                    Button(action:{
                        // Deselect driver and selected annotation
                        manager.selectedDriver = nil
                        manager.selectedAnnotation = nil
                        
                        builderVm.builderStates = .rideOverView
                        manager.snapToRoute = true
                    } , label: {
                        Image(systemName: "chevron.right")
                    }).padding()
                    .buttonStyle(.borderedProminent)
                }
                List {
                    Text("Select your drivers").font(.subheadline).bold()
                    // Section of all accpeted drivers
                    Section(header:Text("Selected")) {
                        ForEach(manager.drivers.indices, id: \.self) { index in
                            Button {
                                // set the selected driver
                                manager.selectedDriver = manager.drivers[index]
                                // prop manager to snap to driver map annotation
                                manager.changeRegion(driver: manager.selectedDriver!.address)
                            } label: {
                                
                                let rate:String = String(format: "%.1f", manager.drivers[index].rateAppliedToRide)
                                Text("Price: $\(rate)")
                                
                                Text(manager.drivers[index].address)
                                    .font(.footnote)
                                
                               
                            }
                        }.onMove(perform: move)
                        .onDelete(perform: delete)
                    }
                    // Section of rejected drivers
                    Section(header: Text("Rejected")){
                        ForEach(manager.rejectedDrivers.indices, id: \.self) { index in
                            Button {
                                manager.selectedDriver = manager.rejectedDrivers[index]
                                manager.changeRegion(driver: manager.selectedDriver!.address)
                            } label: {
                                
                                if manager.rejectedDrivers[index].rateAppliedToRide != nil {
                                    
                                    let rate:String = String(format: "%.1f", manager.rejectedDrivers[index].rateAppliedToRide)
                                    Text("Price: \(rate)")
                                }else{
                                    Text("Driver Rate: \(manager.rejectedDrivers[index].info!.rate!.description)")
                                }
                                
                                Text(manager.rejectedDrivers[index].address)
                                    .font(.footnote)
                                
                               
                            }
                        }.onDelete(perform: deleteRejected)
                    }
                    
                }.frame(height: 200)
                .listStyle(.grouped)
       
             .navigationBarItems(trailing: EditButton())
      
        }
    }
    
    // Allows user to rearrange drivers by priority
    func move(from source: IndexSet, to destination: Int) {
        
        manager.drivers.move(fromOffsets: source, toOffset: destination)
     }
    
    // Removes driver from accepted and inserts into the rejected drivers
    func delete(at offsets: IndexSet) {
            let rejectDriver = manager.drivers[offsets.first!]
            manager.drivers.remove(atOffsets: offsets)
            manager.rejectedDrivers.append(rejectDriver)
            //manager.rejectedDrivers.insert(rejectDriver, at: offsets.first!)

    }
    
    // Removes driver from rejected and inserts into the accepted drivers
    func deleteRejected(at offsets: IndexSet){
        let rejectDriver = manager.rejectedDrivers[offsets.first!]
        manager.rejectedDrivers.remove(atOffsets: offsets)
        manager.drivers.append( rejectDriver)
        //manager.drivers.insert(rejectDriver, at: offsets.first!)
    }
    
    
}

struct SelectDrivers_Previews: PreviewProvider {
    static var previews: some View {
        SelectDrivers()
    }
}
