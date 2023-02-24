//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 24.02.2023.
//

import Foundation
final class RMCharacterDetailViewViewModel{
    private let character: RMCharacter
    init(character: RMCharacter){
        self.character = character
    }
    public var title: String{
        return character.name.uppercased()
    }
}
