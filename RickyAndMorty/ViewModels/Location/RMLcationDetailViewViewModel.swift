//
//  RMLcationDetailViewViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/25.
//

import UIKit
import Combine

protocol RMLocationDetailViewViewModelDeleagate: AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel: NSObject {
    
    private var endpointUrl: URL?
    public weak var delegate: RMLocationDetailViewViewModelDeleagate?
    
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModel: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    public private(set) var cellViewModels: [SectionType] = []
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
    }
    
    // MARK: - Public
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else { return nil}
        return dataTuple.characters[index]
    }
    // MARK: - Private
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let location = dataTuple.location
        let characters = dataTuple.characters
        var createdString = location.created
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        cellViewModels = [
            .information(viewModel: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Create", value: createdString),
            ]),
            .characters(viewModel: characters.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageUrl: URL(string: $0.image))
            }))
        ]
    }
    
    /// Fetch backing location model
    public func fetchLocationData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        
        RMService.shared.execute(request, expecting: RMLocation.self).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let failure):
                print(failure)
            }
        } receiveValue: { [weak self] model in
            self?.fetchRelatedCharacter(location: model)
        }.store(in: &cancellables)
    }
    
    private func fetchRelatedCharacter(location: RMLocation) {
        let requests: [RMRequest] = location.residents.compactMap({
            return URL(string: $0)
        }).compactMap({
            return RMRequest(url: $0)
        })
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
                case .failure(_):
                    break
                }
            } receiveValue: { model in
                characters.append(model)
            }.store(in: &cancellables)
        }
        group.notify(queue: .main) {
            self.dataTuple = (
                location: location,
                characters: characters
            )
        }
    }
}
