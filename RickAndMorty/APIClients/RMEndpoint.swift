//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Onur Celik on 23.02.2023.
//

import Foundation

/// Represents unique API endpoint
@frozen enum RMEndpoint: String,CaseIterable,Hashable{
    case character // "character"
    case location
    case episode
}
