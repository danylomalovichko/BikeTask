//
//  Location.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 24.10.2023.
//

import CoreLocation

struct Location: Equatable {
    let latitude: Double
    let longitude: Double
    let altitude: Double
    let accuracy: Double

    public init(latitude: Double = 0, longitude: Double = 0, altitude: Double = 0, accuracy: Double = 0) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.accuracy = accuracy
    }
    
    var coordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
