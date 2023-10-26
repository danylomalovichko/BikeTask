//
//  DependencyContainer.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 23.10.2023.
//

import Foundation

@MainActor
class DependencyContainer {
    
   let geolocator: GeolocatorService
   let network: NetworkService

    init() {
        geolocator = GeolocatorManager()
        network = NetworkManager()
    }
}
