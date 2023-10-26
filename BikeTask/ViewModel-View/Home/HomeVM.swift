//
//  HomeVM.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 23.10.2023.
//

import Foundation

@MainActor
class HomeVM: BaseVM {
    
    @Published var currentLocation: Location?
    @Published var stations: [Stations] = []
    @Published var stationsWithDistance: [Stations] = []
    @Published var showingAlert = false
    @Published var errorMessage: String?
    
    override init(_ container: DependencyContainer) {
        
        super.init(container)
        
        container.geolocator.currentUserLocation
            .eraseToAnyPublisher()
            .assign(to: &$currentLocation)
        
        $currentLocation
            .sink { location in
                self.updateStations()
            }
            .store(in: &bag)
        
        
        setup()
    }
    
    private func updateStations() {
        if currentLocation == nil {
            stationsWithDistance = stations
            stationsWithDistance.sort(by: { $0.name < $1.name } )
        } else {
            stationsWithDistance = []
            stations.forEach { station in
                var newStation = station
                newStation.distance = station.distanceInKmTo(location: currentLocation)
                stationsWithDistance.append(newStation)
            }
            stationsWithDistance.sort(by: { $0.distance ?? 0 < $1.distance ?? 0 } )
        }
       
    }
    
    private func setup() {
        switch container.geolocator.currentAuthorizationStatus {
        case .notDetermined:
            container.geolocator.requestAlwaysAuthorizationIfNotDetermined()
        case .authorized:
            container.geolocator.enableLocationTracking()
        case .denied:
            print("denied")
        }
    }
    
    func fetchStations() async {
        container.network.fetchStations()
            .sink { dataResponse in
                if dataResponse.error != nil {
                    guard let error = dataResponse.error else {
                        return
                    }
                    self.errorMessage = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
                    self.showingAlert = true
                } else {
                    self.stations = dataResponse.value?.network.stations ?? []
                    self.updateStations()
                }
            }
            .store(in: &bag)
    }
}
