//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/8/15.
//

import Foundation

final class RMCharacterInfoCollectionViewCellViewModel {
    private let value: String
    private let title: String
    init(
        value: String,
        title: String
    ) {
        self.value = value
        self.title = title
    }
}
