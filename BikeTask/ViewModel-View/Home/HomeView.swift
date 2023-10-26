//
//  HomeView.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 24.10.2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeVM
    
    var body: some View {
        List {
            ForEach(vm.stationsWithDistance, id: \.self) { station in
                Link(destination: URL(string: "http://maps.apple.com/?ll=\(station.latitude),\(station.longitude)")!) {
                    HStack {
                        VStack {
                            Text(station.name)
                                .foregroundColor(.black)
                                .bold()
                            
                            Text("Free bikes: \(station.freeBikes ?? 0)")
                                .foregroundColor(.black)
                            
                            Text("Empty bike slots: \(station.emptySlots ?? 0)")
                                .foregroundColor(.black)
                            
                            Text("Distance to station: \(station.distanceInKmTo(location: vm.currentLocation))km")
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
        }
        .onAppear {
            Task {
                await vm.fetchStations()
            }
            
        }
        .refreshable {
            await vm.fetchStations()
        }
        .alert(vm.errorMessage ?? "Unknown", isPresented: $vm.showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}
