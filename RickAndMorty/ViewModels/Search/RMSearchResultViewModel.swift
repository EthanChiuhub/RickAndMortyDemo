//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2024/3/22.
//

import Foundation


enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationViewCellViewModel])
}
