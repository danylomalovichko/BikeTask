//
//  BaseError.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 23.10.2023.
//

import Foundation
import SwiftUI

public enum BaseError: Error {
    case error
    case notImplementedYet
    case somethingWhenWrong(message: String)
    
    private func generalDescription() -> String {
        switch self {
        case .error:
            return "An Unexpected Error Occurred"
        case .notImplementedYet:
            return "Not implemented yet"
        case .somethingWhenWrong(let message):
            return message
        }
    }
}

extension BaseError: LocalizedError {
    public var errorDescription: String? {
        generalDescription()
    }
}

extension BaseError: CustomStringConvertible {
    public var description: String {
        generalDescription()
    }
}
