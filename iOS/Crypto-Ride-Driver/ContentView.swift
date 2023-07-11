//
//  ContentView.swift
//  Crypto-Ride-Driver
//
//  Created by mitchell tucker on 7/7/23.
//


import SwiftUI

// Driver states for the content views
enum DriverStates {
    case unknown
    case notRegistered
    case noRide
    case inRide
}

struct ContentView: View {
    
    @EnvironmentObject var authentication:Authentication
    //@StateObject var manager = LocationManager()
    
    @StateObject var registered = Registered()
    @StateObject var balance = Balance()
    @StateObject var driver = Driver()
    
    @State var isLoading = false
    
    @ObservedObject var rideService:RideService
    //@ObservedObject var webSocket:WebSockets

    let mapView:MapView = MapView()
    
    init() {
        rideService = RideService() // password is need to sign tx
        //webSocket = WebSockets()
        // setup rideState observer from webSocket to rideService
        //rideService.observeRideState(propertyToObserve: webSocket.$rideState)
    }
    
    
    // MARK: containedView
    /// Switch views based on `driverState`
    /// Views will be presented ontop of mapView
    func subView() -> AnyView {
        switch rideService.driverState {
        case .unknown:
            return AnyView(Text("Unkown view"))
        case .notRegistered:
            return AnyView(Text("Unkown view"))
        case .noRide:
            return AnyView(
                ListenView()
                    .environmentObject(rideService)
            )
        case .inRide:
            return AnyView(Text("Unkown view"))
        }
    }
    
    
    var body: some View {
        NavigationView {
            ZStack {
                    mapView
                        //.environmentObject(manager)
                        //.environmentObject(rideService)
                        .environmentObject(driver)
                        .edgesIgnoringSafeArea(.all)
                
                    subView()
            }
            .task {
                /*
                // Get driver address
                let driverAddress = ContractServices.shared.getWallet().address
                // check if driver is registered
                rideService.isDriver(address:driverAddress ) {
                    isDriver in
                        registered.isRegistered = isDriver
                        
                    if isDriver {
                        // If registered check if driver is in active ride
                        rideService.getActiveRide(address: driverAddress) {
                            rideId in
                            // Check if rideId is empty
                            if rideId == ZERO_BYTES {
                                rideService.driverState = .noRide
                            }else{
                                // set observables rideId's
                                webSocket.rideId = rideId
                                rideService.rideId = rideId
                                // get ride details
                                rideService.getRide(rideId: rideId) {
                                    ride in
                                    rideService.ride = ride
                                    rideService.updateRoute = true
                                    rideService.showPickUpRoute = true
                                
                                }
                                // set view state to inRide
                                rideService.driverState = .inRide
                            }
                        }
                    }else{
                        // set view state to not registered
                        rideService.driverState = .notRegistered
                    }
                }
                */
            }
            .buttonStyle(.borderedProminent)
                .safeAreaInset(edge: .top, content: {
                    Color.clear
                        .frame(height: 0)
                        .background(.bar)
                        .border(.black)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                            Button("Logout") {
                                //webSocket.disconnectSocket()
                                //manager.deleteDB()
                                authentication.updateAuthState(goto: .login)
                            }
                        }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ProfileView()
                                                                 .environmentObject(balance)
                                                                 .environmentObject(driver)
                                                                 //.environmentObject(registered)
                        ){
                            Image(systemName: "person.crop.circle")
                        }
                    }

                }
                .navigationTitle("")
                .navigationViewStyle(StackNavigationViewStyle())
                .navigationBarTitleDisplayMode(.inline)
 
                /*
                .alert(item:$rideService.error) { error in
                    Alert(title: Text(error.title), message: Text(error.description), dismissButton: .cancel() {
                        rideService.error = nil
                            //rideService.sendingWriteTx = false
                            print("Dismissed")
                    })
                 
                }
                 */
           
        }
    }
}
