//
//  NetworkService.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 23.10.2023.
//

import Alamofire
import Combine
import Foundation

@MainActor
protocol NetworkService {
    func fetchStations() -> AnyPublisher<DataResponse<RequestResult, NetworkError>, Never>
}

class NetworkManager: NetworkService {
    
    var stations: CurrentValueSubject<[Stations], Never> = .init([])
    let server = "https://api.citybik.es"
    
    func fetchStations() -> AnyPublisher<DataResponse<RequestResult, NetworkError>, Never> {
        AF.request("\(server)/v2/networks/wienmobil-rad")
            .validate()
            .publishDecodable(type: RequestResult.self, decoder: JSONDecoder.decoder)
            .map { response in
                return response.mapError { error in
                    let backendError = response.data
                        .flatMap {
                            try? JSONDecoder.decoder.decode(BackendError.self, from: $0)
                        }
                    
                    return NetworkError(initialError: error, backendError: backendError)
                }
            }
            .eraseToAnyPublisher()
    }
}
