//
//  NetworkManager.swift
//  AutoSampleApp
//
//  Created by Harsh Hungund on 05/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import Foundation

enum NetworkResponse:String {
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
}

enum Result<String>{
    case success
    case failure(String)
}

struct NetworkManager {
    let router = Router<CountriesEndPoint>()
    
    func getEndpointData(_ endPoint : CountriesEndPoint, completion: @escaping (_ data: Data?,_ response: URLResponse?,_ error: Error?) ->()){
        router.request(endPoint) { data, response, error in
            completion(data, response, error)
        }
    }
    
     func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
        }
    }
}
