//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/8/15.
//

import Foundation

final class RMCharacterEpisodeCollectionViewCellViewModel {
    private let episodeDataUrl: URL?

    init(
        episodeDataUrl: URL?
    ) {
        self.episodeDataUrl = episodeDataUrl
    }
}
