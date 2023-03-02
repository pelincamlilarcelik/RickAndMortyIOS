//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import Foundation
struct  RMLocationTableViewCellViewModel:Equatable,Hashable{
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(dimension)
        hasher.combine(location.id)
    }
    
    let location: RMLocation
    init(location: RMLocation) {
        self.location = location
    }
    public var name: String{
        return location.name
    }
    public var type: String{
        return location.type
    }
    public var dimension: String{
        return location.dimension
    }
}
