//
//  GeolocatorService.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 24.10.2023.
//

import MapKit
import Combine

@MainActor
protocol GeolocatorService {
    var currentAuthorizationStatus: GeolocatorManager.AuthorizationStatus { get }
    var authorizationStatusPublisher: CurrentValueSubject<GeolocatorManager.AuthorizationStatus, Never> { get }
    
    var currentUserLocation: CurrentValueSubject<Location?, Never> { get }
        
    func requestAlwaysAuthorizationIfNotDetermined()
    func requestWhenInUseAuthorizationIfNotDetermined()
    
    func enableLocationTracking()
    func disableLocationTracking()
    
}

final class GeolocatorManager: NSObject, GeolocatorService {
    
    enum AuthorizationStatus {
        case authorized
        case denied
        case notDetermined
    }
    
    let authorizationStatusPublisher = CurrentValueSubject<GeolocatorManager.AuthorizationStatus, Never>(.notDetermined)
    
    let currentUserLocation = CurrentValueSubject<Location?, Never>(nil)
    
    
    private(set) var lastLocation: Location?
    private(set) var locationTrackingEnabled = false
    
    var currentAuthorizationStatus: GeolocatorManager.AuthorizationStatus {
        makeAuthorizationStatus()
    }
    
    private let locationManager: CLLocationManager
    
    public override init() {
        self.locationManager = CLLocationManager()
        
        super.init()
        
        authorizationStatusPublisher.send(makeAuthorizationStatus())
        
        locationManager.delegate = self
        
        startIfAuthorized()
    }
    
    private func startIfAuthorized() {
        switch currentAuthorizationStatus {
        case .authorized:
            enableLocationTracking()
        default:
            break
        }
    }
    
    public func enableLocationTracking() {
        guard authorizationStatusPublisher.value == .authorized, !locationTrackingEnabled else { return }
        
        locationTrackingEnabled = true
        locationManager.startUpdatingLocation()
        
        if let clLocation = locationManager.location {
            lastLocation = makeLocation(from: clLocation)
        }
        
        print("Location tracking enabled.")
    }
    
    public func disableLocationTracking() {
        guard locationTrackingEnabled else { return }
        
        locationManager.stopUpdatingLocation()
        locationTrackingEnabled = false
        lastLocation = nil
        
        print("Location tracking disabled.")
    }
    
    public func requestWhenInUseAuthorizationIfNotDetermined() {
        switch authorizationStatusPublisher.value {
        case .authorized, .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func requestAlwaysAuthorizationIfNotDetermined() {
        switch authorizationStatusPublisher.value {
        case .authorized, .denied:
            break
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func makeAuthorizationStatus() -> AuthorizationStatus {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined, .restricted:
            return .notDetermined
        @unknown default:
            assertionFailure("Please implement the new authorizationStatus case \(locationManager.authorizationStatus)")
            return .notDetermined
        }
    }
    
    private func makeLocation(from clLocation: CLLocation) -> Location {
        Location(latitude: clLocation.coordinate.latitude,
                 longitude: clLocation.coordinate.longitude,
                 altitude: clLocation.altitude,
                 accuracy: clLocation.horizontalAccuracy)
    }
}

extension GeolocatorManager: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let newAuthorizationStatus = makeAuthorizationStatus()
        if authorizationStatusPublisher.value != newAuthorizationStatus {
            authorizationStatusPublisher.send(newAuthorizationStatus)
            
            switch newAuthorizationStatus {
            case .denied, .notDetermined:
                disableLocationTracking()
                print("Location tracking permission is denied.")
            default:
                enableLocationTracking()
                print("Location tracking permission is granted.")
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let rawLocation = locations.last else { return }
//        print(rawLocation)
//
        if locationTrackingEnabled {
            lastLocation = makeLocation(from: rawLocation)
            currentUserLocation.send(lastLocation)
        }
//            print("lastLocation: \(String(describing: lastLocation))")
//
//            if selectedPlace.value == nil {
//                guard let lastLocation = lastLocation else {
//                    return
//                }
//                Task {
//                    let address = try await addressFromLocation(lastLocation.coordinate2D)
//                    let place = Place(name: address, location: lastLocation)
//                    selectedPlace.send(place)
//                }
//            }
//        }
    }
}
