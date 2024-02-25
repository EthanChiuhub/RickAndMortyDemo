//
//  RMLocationViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/24.
//

import UIKit
import Combine

protocol RMLocationViewModelDeleagate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewModel {
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    weak var delegate: RMLocationViewModelDeleagate?
    
    // Location response info
    // Will contain next url, if present
    
    private var apiInfo: RMGetLocationsResponse.Info?
    
    public private(set) var cellViewModels: [RMLocationViewCellViewModel] = []
    
    private var cancelables = Set<AnyCancellable>()
    
    init() {}
    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count else {
            return nil
        }
        return self.locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(.listLocationRequests, expecting: RMGetLocationsResponse.self).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                fatalError("Something worng")
            }
        }, receiveValue: { [weak self] model in
            self?.apiInfo = model.info
            self?.locations = model.results
            DispatchQueue.main.async {
                self?.delegate?.didFetchInitialLocations()
            }
        }).store(in: &cancelables)
    }
    
    private var hasMorResults: Bool {
        return false
    }
}
