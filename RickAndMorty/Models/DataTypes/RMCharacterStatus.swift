//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Onur Celik on 23.02.2023.
//

import Foundation
enum RMCharacterStatus: String,Codable{
    case dead = "Dead"
    case alive = "Alive"
    case `unknown` = "unknown"
    
    var text: String{
        switch self{
        case .dead,.alive:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}

