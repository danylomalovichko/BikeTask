//
//  BackendError.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 23.10.2023.
//

import Foundation

struct BackendError: Codable, Error {
    let type: String
    let message: String
}
