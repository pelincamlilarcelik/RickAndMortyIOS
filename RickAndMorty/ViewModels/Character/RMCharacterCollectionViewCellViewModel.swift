//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 24.02.2023.
//

import Foundation
final class RMCharacterCollectionViewCellViewModel: Hashable,Equatable{
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    
    
     let characterName: String
     let characterStatus: RMCharacterStatus
     let characterImageUrl: URL?
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImageUrl)
    }
    
    // MARK: Init
    init(characterName: String, characterStatus: RMCharacterStatus, characterImageUrl: URL?) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImageUrl = characterImageUrl
    }
    
    public var characterStatusText: String{
        return "Status: \(characterStatus.text)"
    }
    public func fetchImage(completion: @escaping (Result<Data,Error>)->Void){
        //TODO: Abstract to ImageManager
        guard let url = characterImageUrl else {
            completion(.failure(URLError(.badURL)))
            return
        }
        let request = URLRequest(url: url)
        RMImageLoader.shared.downloadImage(url: url, completion: completion)
    }
    
}
