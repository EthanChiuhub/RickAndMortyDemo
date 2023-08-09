//
//  RMCharacterDetailViewViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/8/7.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    
    private let character: RMCharacter
    
    init (character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
