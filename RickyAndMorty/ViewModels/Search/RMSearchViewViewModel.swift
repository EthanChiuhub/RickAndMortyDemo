//
//  RMSearchViewViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/3/3.
//

import Foundation
import Combine

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""
    
    private var searchResultHandler: (() -> Void)?
    
    var cancellables = Set<AnyCancellable>()
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    // MARK: - Init
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - PUblic
    
    public func reqisterSearchResultHander(_ block: @escaping () -> Void) {
        self.searchResultHandler = block
    }
    
    public func executeSearch() {
        // Test search text
        searchText = "Rick"
        // Build arguments
        var queryParams: [URLQueryItem] = [URLQueryItem(name: "name", value: searchText)]
        // Create Request based on filters
        // Send API Call
        
        // add option
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
        
        RMService.shared.execute(request, expecting: RMGetAllCharacterResponse.self).sink { completion in
            switch completion {
            case .finished:
                print("API FINISH")
            case .failure(let error):
                print("API ERROR")
            }
        } receiveValue: { result in
            // Notify view of results, no results, or error
            print(String(describing: result.results.count))
        }.store(in: &cancellables)
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
