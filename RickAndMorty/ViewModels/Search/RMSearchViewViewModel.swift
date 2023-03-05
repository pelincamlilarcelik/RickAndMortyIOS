//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import Foundation

// Responsibilities
// show search results
// show no result view
// API requests
final class RMSearchViewViewModel{
    
    let config: RMSearchViewController.Config
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicType:String] = [:]
    
    private var searchText: String = ""
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicType,String))->Void)?
    
    private var searchResultHandler: ( (RMSearchResultViewModel)->Void )?
    
    // MARK: Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel)->Void ){
        self.searchResultHandler = block
    }
    
    public func executeSearch(){
        // Test
        searchText = "Rick"
        
        // Build arguments
        var queryParams : [URLQueryItem] = [URLQueryItem(name: "name", value: searchText)]
        
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _ , element in
            let key : RMSearchInputViewViewModel.DynamicType = element.key
            let value : String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        // Create request
        let request = RMRequest(endpoint: config.type.endpoint,queryParameters: queryParams)
        
        switch config.type.endpoint{
            
        case .character:
            makeSearchAPICall(type: RMGetAllCharactersResponse.self, request: request)
        case .location:
            makeSearchAPICall(type: RMGetAllLocationsResponse.self, request: request)
        case .episode:
            makeSearchAPICall(type: RMGetAllEpisodesResponse.self, request: request)
        }

        
        
        
    }
    private func makeSearchAPICall<T:Codable>(type: T.Type,request:RMRequest ){
        RMService.shared.execute(request, expecting: type) {[weak self] result in
            switch result{
                
            case .success(let model):
                self?.processSearchResult(model: model)
            case .failure(_):
                break
            }
        }
    }
    private func processSearchResult(model:Codable){
        var resultsVM : RMSearchResultViewModel?
        if let charactersResult = model as? RMGetAllCharactersResponse{
            resultsVM = .characters(charactersResult.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image))
            }))
        }else if let locationsResult = model as? RMGetAllLocationsResponse{
            resultsVM = .locations(locationsResult.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
        }else if let episodesResult = model as? RMGetAllEpisodesResponse{
            resultsVM = .episodes(episodesResult.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            }))
        }
            if let results = resultsVM{
                searchResultHandler?(results)
            }
        else{
           // show no result view
        }
    }
    public func set(query text: String){
        self.searchText = text
    }
    
    public func set(value: String,for option: RMSearchInputViewViewModel.DynamicType){
        optionMap[option] = value
        let tuple = (option,value)
        optionMapUpdateBlock?(tuple)
    }
    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicType,String))->Void){
        self.optionMapUpdateBlock = block
    }
}
