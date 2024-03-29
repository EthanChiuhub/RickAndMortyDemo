//
//  RMCharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/31.
//

import Combine
import UIKit

typealias Event<T> = PassthroughSubject<T, Never>
/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject {
    var cancellables = Set<AnyCancellable>()
    
    public let didLoadInitialCharacters = Event<Void>()
    public let didLoadMoreCharacter = Event<[IndexPath]>()
    public let didSelectCharacter = Event<RMCharacter>()
    
    private var isLoadingMoreCharacters = false
    
    private var characters: [RMCharacter] = [] {
        didSet {
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllCharacterResponse.Info! = nil
    
    /// Fetch initial set of characters(20)
    public func fetchCharacters() {
        RMService.shared.execute(.listCharacterRequests,
                                 expecting: RMGetAllCharacterResponse.self)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                self.didLoadInitialCharacters.send()
            case let .failure(error):
                print(String(describing: error))
            }
        }, receiveValue: { [weak self] result in
            let results = result.results
            let info = result.info
            self?.characters = results
            self?.apiInfo = info
        }).store(in: &cancellables)
    }
    
    /// Paginate if additional characters are needed
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        // Fetch characters
        RMService.shared.execute(request,
                                 expecting: RMGetAllCharacterResponse.self)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
            case let .failure(error):
                print(String(describing: error))
                self.isLoadingMoreCharacters = false
            }
        }, receiveValue: { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            let moreResults = result.results
            let info = result.info
            strongSelf.apiInfo = info
            let originalCount = strongSelf.characters.count
            let newCount = moreResults.count
            let total = originalCount + newCount
            let startingIndex = total - newCount
            let indexPAthsToAdd: [IndexPath] = Array(startingIndex ..< (startingIndex + newCount)).compactMap {
                IndexPath(row: $0, section: 0)
            }
            strongSelf.characters.append(contentsOf: moreResults)
            DispatchQueue.main.async {
                strongSelf.didLoadMoreCharacter.send(indexPAthsToAdd)
                strongSelf.isLoadingMoreCharacters = false
            }
        }).store(in: &cancellables)
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - Collection View

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configure(viewModel: cellViewModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let isIphone = UIDevice.current.userInterfaceIdiom == .phone
        let bounds = collectionView.bounds
        let width: CGFloat
        if isIphone {
            width = (bounds.width - 30) / 2
        } else {
            width = (bounds.width - 50) / 4
        }
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        didSelectCharacter.send(character)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                                                                           for: indexPath) as? RMFooterLoadingCollectionReusableView
        else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, referenceSizeForFooterInSection _: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - Scroll View

extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString)
        else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalCharacters(url: url)
            }
            timer.invalidate()
        }
    }
}
