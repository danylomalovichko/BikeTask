//
//  NetworkResult.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 25.10.2023.
//

import Foundation

struct NetworkResult: Codable {
    let id: String
    let stations: [Stations]
}
