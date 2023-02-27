//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 25.02.2023.
//

import Foundation

protocol RMEpisodeDataRenderer{
    var name: String {get}
    var air_date: String {get}
    var episode: String {get}
}

final class RMCharacterEpisodeCollectionViewCellViewModel{
    let episodeDataUrl: URL?
    
    private var isFetching = false
    private var  episode: RMEpisode?{
        didSet{
            guard let model = episode else{
                return
            }
            dataBlock?(model)
        }
    }
    var dataBlock: ((RMEpisodeDataRenderer)-> Void)?
    //MARK: Public
    
    public func registerForData(_ block: @escaping (RMEpisodeDataRenderer)-> Void){
        self.dataBlock = block
    }
    
    //MARK: Init
    init(episodeDataUrl: URL?) {
        self.episodeDataUrl = episodeDataUrl
    }
    public func fetchEpisode(){
        guard !isFetching else {
            if let model = episode{
                self.dataBlock?(model)
            }
            return
            }
        
        guard let url = episodeDataUrl ,let request = RMRequest(url: url) else{
            return
        }
        isFetching = true
        RMService.shared.execute(request,expecting: RMEpisode.self) {[weak self] result in
            switch result{
                
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}
