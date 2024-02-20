//
//  RMEpisodeDetailViewViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/16.
//

import UIKit
import Combine

protocol RMEpisodeDetailViewViewModelDeleagate: AnyObject {
    func didFetchEpisodeDetails()
}

final class RMEpisodeDetailViewViewModel: NSObject {
    
    private var endpointUrl: URL?
    public weak var delegate: RMEpisodeDetailViewViewModelDeleagate?
    
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            delegate?.didFetchEpisodeDetails()
        }
    }
    
    enum SectionType {
        case information(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewMode: [RMCharacterCollectionViewCellViewModel])
    }
    
    public private(set) var sections: [SectionType] = []
    
    var cancellables = Set<AnyCancellable>()

     // MARK: - Init
    init(endpointUrl: URL?) {
        super.init()
        self.endpointUrl = endpointUrl
    }
    
     // MARK: - Public
    
     // MARK: - Private
    /// Fetch backing episode model
    public func fetchEpisodeData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMEpisode.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                print(failure)
            }
        } receiveValue: { [weak self] model in
            self?.fetchRelatedCharacter(episode: model)
        }.store(in: &cancellables)
    }
    
    private func fetchRelatedCharacter(episode: RMEpisode) {
        let requests: [RMRequest] = episode.characters.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
        
        // 10 of parallel requests
        
        //notified once all done
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self).sink { completion in
                defer {
                    group.leave()
                }
                switch completion {
                case .finished:
                    break
                case .failure(let failure):
                    break
                }
            } receiveValue: { model in
                characters.append(model)
            }.store(in: &cancellables)
        }
        group.notify(queue: .main) {
            self.dataTuple = (
            episode,
            characters
            )
        }
    }

}
