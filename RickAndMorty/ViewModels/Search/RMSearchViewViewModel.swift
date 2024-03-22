//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2024/3/3.
//

import Foundation
import Combine

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""
    
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    
    var cancellables = Set<AnyCancellable>()
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - PUblic
    
    public func reqisterSearchResultHander(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func executeSearch() {
        print("Search text: \(String(describing: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))")
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText)]
        queryParams.append(contentsOf: optionMap.enumerated().compactMap({ _, element in
            let key: RMSearchInputViewViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        }))
        // Create request
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharacterResponse.self, request: request)
            
        case .episode:
            makeSearchAPICall(RMGetEpisodesResponse.self, request: request)
            
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        }
    }
    
    private func makeSearchAPICall<T: Codable> (_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type).sink { completion in
            switch completion {
            case .finished:
                print("API FINISH")
            case .failure(let error):
                print("API ERROR: \(error)")
            }
        } receiveValue: { [weak self] result in
            self?.processSearchResults(model: result)
        }.store(in: &cancellables)
    }
    
    private func processSearchResults(model: Codable) {
        var resultsVM: RMSearchResultViewModel?
        if let characterResults = model as? RMGetAllCharacterResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image))
            }))
        } else if let episodeResults = model as? RMGetEpisodesResponse {
            resultsVM = .episodes(episodeResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: $0.url)
                )}))
        } else if let locationResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationResults.results.compactMap({
                return RMLocationViewCellViewModel(location: $0)
            }))
        } else {
            print("Unknown result type")
        }
        
        if let results = resultsVM {
            self.searchResultHandler?(results)
        } else {
            // fallback error
        }
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(
        _ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void) {
            self.optionMapUpdateBlock = block
        }
}
