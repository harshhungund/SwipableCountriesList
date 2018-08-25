//
//  AutoSampleApp
//
//  Created by Harsh Hungund on 05/08/18.
//  Copyright © 2018 Harsh Hungund. All rights reserved.
//

import Foundation

public enum CountriesEndPoint {
    case countries
}

extension CountriesEndPoint: EndPointType {
    
    var baseURL: URL {
        let str = URLParameterConstants.BASE_URL
        
        guard let url = URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
            else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .countries:
            return ""
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var task: HTTPTask {
        switch self {
        case .countries:
            return  .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}


