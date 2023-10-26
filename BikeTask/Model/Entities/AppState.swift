//
//  AppState.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 24.10.2023.
//

import Foundation

class AppState: ObservableObject {
    @Published var container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
}
