//
//  RMSearchResultViewType.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2024/3/22.
//

import Foundation
import Combine

final class RMSearchResultViewModel {
    public private (set) var results: RMSearchResultViewType
    private var next: String?
    
    init(results: RMSearchResultViewType, next: String?) {
        self.results = results
        self.next = next
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    public private (set) var isLoadingMoreResults = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(String(describing: error))
                    self.isLoadingMoreResults = false
                }
            } receiveValue: { [weak self] responseModel in
                guard let strongSelf = self else { return }
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next // Capture new pagination url
                
                let additionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                })
                var newResults: [RMLocationTableViewCellViewModel] = []
                switch strongSelf.results {
                case .locations(let existingResults):
                    newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                    break
                case .characters, .episodes:
                    break
                }
            }.store(in: &cancellables)
    }
    
    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else {
            return
        }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreResults = true
        
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        switch results {
        case .characters(let existingResults):
            RMService.shared.execute(request,
                                     expecting: RMGetAllCharacterResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(String(describing: error))
                    self.isLoadingMoreResults = false
                }
            }, receiveValue: { [weak self] responseModel in
                guard let strongSelf = self else {
                    return
                }
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next
                let additionalResults = moreResults.compactMap({
                    return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                                  characterStatus: $0.status, characterImageUrl: URL(string: $0.image))
                })
                var newResults: [RMCharacterCollectionViewCellViewModel] = []
                newResults = existingResults + additionalResults
                strongSelf.results = .characters(newResults)
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    // Notify via callback
                    completion(newResults)
                }
            }).store(in: &cancellables)
        case .episodes(let existingResults):
            RMService.shared.execute(request,
                                     expecting: RMGetAllEpisodesResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(String(describing: error))
                    self.isLoadingMoreResults = false
                }
            }, receiveValue: { [weak self] responseModel in
                guard let strongSelf = self else {
                    return
                }
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next
                let additionalResults = moreResults.compactMap({
                    return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                })
                var newResults: [RMCharacterEpisodeCollectionViewCellViewModel] = []
                newResults = existingResults + additionalResults
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    // Notify via callback
                    completion(newResults)
                }
            }).store(in: &cancellables)
        case .locations:
            // TablewView case
            break
        }
        // Fetch characters
        
    }
}

enum RMSearchResultViewType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
