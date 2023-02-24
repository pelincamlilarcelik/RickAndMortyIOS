//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Onur Celik on 23.02.2023.
//

import Foundation
final class RMRequest{
    /// API Constants
    private struct Constants{
        static let baseUrl = "https://rickandmortyapi.com/api"
        
    }
    /// Desired endpoint
    private let endpoint: RMEndpoint
    private let pathComponents: Set<String>
    private let queryParameters: [URLQueryItem]
       /// Contructed url for the api request in string format
        private var urlString: String{
            var string = Constants.baseUrl
            string += "/"
            string += "\(endpoint.rawValue)"
            if !pathComponents.isEmpty{
                pathComponents.forEach({
                    string += "/\($0)"
                })
            }
            if !queryParameters.isEmpty{
                string += "?"
                let argumentString = queryParameters.compactMap({
                    guard let value = $0.value else {return nil}
                    return  "\($0.name)=\(value)"
                }).joined(separator: "&")
                string += argumentString
            }
            
            return string
        }
    /// Computed and constructed API url
        public var url: URL?{
            return URL(string: urlString)
        }
    /// Desired http method
    public let httpMethod = "GET"
        
        // MARK: Public
        
        init(endpoint: RMEndpoint, pathComponents: Set<String> = [], queryParameters: [URLQueryItem] = []) {
            self.endpoint = endpoint
            self.pathComponents = pathComponents
            self.queryParameters = queryParameters
        }
    
}
