//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import Foundation
protocol RMLocationViewModelDelegate: AnyObject{
    func didFetchInitialLocations()
}

final class RMLocationViewModel{
    weak var delegate: RMLocationViewModelDelegate?
    private var locations: [RMLocation] = []{
        didSet{
            for location in locations{
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel){
                    cellViewModels.append(cellViewModel)

                }
            }
        }
    }
    
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    public func location(at index: Int)->RMLocation?{
        guard index <= locations.count else {return nil}
        return locations[index]
    }
    
    init(){}
    // location response
    // will contain next url if exitst
    
    public func fetchLocations(){
        RMService.shared.execute(
            .listLocationRequest,
            expecting: RMGetAllLocationsResponse.self) { [weak self]result in
            switch result{
                
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
                
            case .failure(let error):
                break
            }
        }
    }
    private var hasMoreResults: Bool{
        return false
    }
}
