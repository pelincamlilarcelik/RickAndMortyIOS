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
    private let pathComponents: [String]
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
        
        init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
            self.endpoint = endpoint
            self.pathComponents = pathComponents
            self.queryParameters = queryParameters
        }
    convenience init?(url:URL){
        let string = url.absoluteString
        if !string.contains(Constants.baseUrl){
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        if trimmed.contains("/"){
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty{
                let endpointString = components[0]
                var pathComponents = [String]()
                if components.count > 1{
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    self.init(endpoint: rmEndpoint,pathComponents: pathComponents)
                    return
                }
                
            }
        }else if trimmed.contains("?"){
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty,components.count >= 2{
                let endpointString = components[0]
                let queryItemString = components[1]
                // name=value&name=value
                let queryItems: [URLQueryItem] = queryItemString.components(separatedBy: "&").compactMap({
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name:parts[0] ,
                                        value:parts[1] )
                })
                if let rmEndpoint = RMEndpoint(rawValue: endpointString){
                    self.init(endpoint: rmEndpoint,queryParameters: queryItems)
                    return
                }
                
            }
        }
        return nil
        
    }
    
}
extension RMRequest{
    static let listCharacterRequest = RMRequest(endpoint: .character)
}
