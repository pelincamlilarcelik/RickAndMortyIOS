//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import Foundation
final class RMLocationViewModel{
    
    private var locations: [RMLocation] = []
    
    private var cellViewModels: [String] = []
    
    init(){}
    // location response
    // will contain next url if exitst
    
    public func fetchLocations(){
        RMService.shared.execute(.listLocationRequest, expecting: String.self) { result in
            switch result{
                
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
    private var hasMoreResults: Bool{
        return false
    }
}
