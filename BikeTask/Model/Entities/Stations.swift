//
//  Stations.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 25.10.2023.
//

import Foundation
import CoreLocation

struct Stations: Codable, Hashable {
    let emptySlots: Int?
    let freeBikes: Int?
    let latitude: Double
    let longitude: Double
    let name: String
    var distance: Float?
}

extension Stations {
    func distanceInKmTo(location: Location?) -> Float {
        guard let location else {
            return 0
        }
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        return Float(coordinate.distance(from: location.coordinate2D) / 1000)
    }
}
