//
//  NetworkError.swift
//  BikeTask
//
//  Created by Danylo Malovichko on 25.10.2023.
//

import Alamofire

struct NetworkError: Error {
  let initialError: AFError
  let backendError: BackendError?
}
