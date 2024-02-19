//
//  RMEpisodeListViewViewModel.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/31.
//

import Combine
import UIKit

/// View Model to handle Episodes list view logic
final class RMEpisodeListViewViewModel: NSObject {
    var cancellables = Set<AnyCancellable>()

    public let didLoadInitialEpisodes = Event<Void>()
    public let didLoadMoreEpisode = Event<[IndexPath]>()
    public let didSelectEpisode = Event<RMEpisode>()

    private var isLoadingMoreEpisodes = false

    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url))
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []

    private var apiInfo: RMGetEpisodesResponse.Info! = nil

    /// Fetch initial set of characters(20)
    public func fetchEpisodes() {
        RMService.shared.execute(.listEpisodeRequests,
                                 expecting: RMGetEpisodesResponse.self)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.didLoadInitialEpisodes.send()
                case let .failure(error):
                    print(String(describing: error))
                }
            }, receiveValue: { [weak self] result in
                let results = result.results
                let info = result.info
                self?.episodes = results
                self?.apiInfo = info
            }).store(in: &cancellables)
    }

    /// Paginate if additional episodes are needed
    public func fetchAdditionalEpisodes(url: URL) {
        guard !isLoadingMoreEpisodes else {
            return
        }
        isLoadingMoreEpisodes = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            return
        }
        // Fetch characters
        RMService.shared.execute(request,
                                 expecting: RMGetEpisodesResponse.self)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    print(String(describing: error))
                    self.isLoadingMoreEpisodes = false
                }
            }, receiveValue: { [weak self] result in
                guard let strongSelf = self else {
                    return
                }
                let moreResults = result.results
                let info = result.info
                strongSelf.apiInfo = info
                let originalCount = strongSelf.episodes.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPAthsToAdd: [IndexPath] = Array(startingIndex ..< (startingIndex + newCount)).compactMap {
                    IndexPath(row: $0, section: 0)
                }
                strongSelf.episodes.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    strongSelf.didLoadMoreEpisode.send(indexPAthsToAdd)
                    strongSelf.isLoadingMoreEpisodes = false
                }
            }).store(in: &cancellables)
    }

    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - Collection View

extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
                                                            for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        cell.configer(with: cellViewModels[indexPath.row])
        return cell
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        didSelectEpisode.send(episode)
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

extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes,
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
                self?.fetchAdditionalEpisodes(url: url)
            }
            timer.invalidate()
        }
    }
}
