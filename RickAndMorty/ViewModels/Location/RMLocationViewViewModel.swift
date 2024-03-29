//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/24.
//

import UIKit
import Combine

protocol RMLocationViewModelDeleagate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    weak var delegate: RMLocationViewModelDeleagate?
    
    // Location response info
    // Will contain next url, if present
    
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public var isLoadingMoreLocations = false
    
    private var cancellables = Set<AnyCancellable>()
    
     // MARK: - Init
    init() {}
    
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations else {
            return
        }
        
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }
        
        isLoadingMoreLocations = true
        
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }
        // Fetch characters
        RMService.shared.execute(request,
                                 expecting: RMGetAllLocationsResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(String(describing: error))
                    self.isLoadingMoreLocations = false
                }
            }, receiveValue: { [weak self] responseModel in
                guard let strongSelf = self else {
                    return
                }
                let moreResults = responseModel.results
                let info = responseModel.info
                print("More Location: \(moreResults.count)")
                strongSelf.apiInfo = info
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return RMLocationTableViewCellViewModel(location: $0)
                }))
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false
                }
            }).store(in: &cancellables)
    }
    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count else {
            return nil
        }
        return self.locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(.listLocationRequests, expecting: RMGetAllLocationsResponse.self).sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case .failure(_):
                fatalError("Something wrong")
                #warning("handle error")
            }
        }, receiveValue: { [weak self] model in
            self?.apiInfo = model.info
            self?.locations = model.results
            DispatchQueue.main.async {
                self?.delegate?.didFetchInitialLocations()
            }
        }).store(in: &cancellables)
    }
    
    private var hasMorResults: Bool {
        return false
    }
}
