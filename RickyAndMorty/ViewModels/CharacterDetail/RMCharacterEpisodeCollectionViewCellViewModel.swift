//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/8/15.
//

import Foundation
import Combine

protocol RMEpisodeDataRender {
    var name: String { get }
    var airdate: String { get }
    var episode: String { get }
}

final class RMCharacterEpisodeCollectionViewCellViewModel {
    private let episodeDataUrl: URL?
    
    private var isFetching = false
    
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?
    
    private var episode: RMEpisode? {
        didSet {
            guard let model = episode else { 
                return
            }
            dataBlock?(model)
        }
    }
    
    var cancellables = Set<AnyCancellable>()

     // MARK: - Init
    init(
        episodeDataUrl: URL?
    ) {
        self.episodeDataUrl = episodeDataUrl
    }
     // MARK: - Public
    public func registerForData(_ block: @escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock = block
    }
    
    public func fetchEpisode() {
        guard !isFetching else {
            if let model = episode {
                dataBlock?(model)
            }
            return
        }
        guard let url = episodeDataUrl, let request = RMRequest(url: url) else {
            return
        }
        isFetching = true
        RMService.shared.execute(request, expecting: RMEpisode.self).sink(receiveCompletion: {
            completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                print(failure)
            }
        }, receiveValue: { model in
            self.episode = model
        }).store(in: &cancellables)

    }
}
