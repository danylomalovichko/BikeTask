//
//  CLLCoordinate2D.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 25.10.2023.
//

import CoreLocation

extension CLLocationCoordinate2D {
    // Distance in meters
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
