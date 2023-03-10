//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 3.03.2023.
//

import Foundation


enum RMSearchResultViewModel{
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
    
    
}
