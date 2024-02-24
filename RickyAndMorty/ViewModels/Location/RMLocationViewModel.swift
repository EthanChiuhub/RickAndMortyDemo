//
//  RMLocationViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/24.
//

import UIKit
import Combine

final class RMLocationViewModel {
    
    private var locations: [RMLocation] = []
    
    // Location response info
    // Will contain next url, if present
    
    private var cellViewModels: [String] = []
    
    private var cancelables = Set<AnyCancellable>()
    
    init() {}
    
    public func fetchLocations() {
        RMService.shared.execute(.listLocationRequests, expecting: String.self).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                fatalError("Something worng")
            }
        }, receiveValue: { string in
            print(string)
        }).store(in: &cancelables)
    }
    
    private var hasMorResults: Bool {
        return false
    }
}
