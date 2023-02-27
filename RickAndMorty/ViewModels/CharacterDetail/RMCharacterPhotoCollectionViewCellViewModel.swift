//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 25.02.2023.
//

import UIKit
final class RMCharacterPhotoCollectionViewCellViewModel{
    private let imageUrl: URL?
    
    
    
    init(imageUrl:URL?){
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(completion: @escaping (Result<Data,Error>)->Void){
        guard let url = imageUrl else {
            completion(.failure(URLError(.badURL)))
            return
            }
        RMImageLoader.shared.downloadImage(url: url, completion: completion)
    }
}
