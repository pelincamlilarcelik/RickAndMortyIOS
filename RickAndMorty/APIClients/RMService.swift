//
//  RMService.swift
//  RickAndMorty
//
//  Created by Onur Celik on 23.02.2023.
//

import Foundation

/// Primary API service object to get Rick and Morty data
final class RMService{
    
    /// Shared singleton instance
    static let shared = RMService()
    
    /// Privatized constructor
    private init(){}
    
    public func execute(_ request: RMRequest,completion: @escaping ()->Void){
        
    }
}