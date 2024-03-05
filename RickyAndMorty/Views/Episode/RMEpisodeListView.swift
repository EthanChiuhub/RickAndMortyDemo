//
//  RMEpisodeListView.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/19.
//

import Combine
import UIKit

/// View that handles showing list of episode. loader. etc
final class RMEpisodeListView: UIView {
    var cancellables = Set<AnyCancellable>()

    private let viewModel = RMEpisodeListViewViewModel()

    public let rmRMEpisodeListView = PassthroughSubject<(RMEpisodeListView,
                                                         RMEpisode), Never>()

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(spinner, collectionView)
        addConstraints()
        spinner.startAnimating()
        viewModel.fetchEpisodes()
        setUpCollectionView()
        subscribeEvent()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Unsupported")
    }

    /// Subscribe ViewModel event
    private func subscribeEvent() {
        didLoadInitialEpisodes()
        didLoadMoreEpisodes()
        didSelectEpisode(rmEpisodeListView: self)
    }

    private func addConstraints() {
        spinner.snp.makeConstraints { make in
            make.height.width.equalTo(100)
            make.centerX.centerY.equalTo(self)
        }

        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }

    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension RMEpisodeListView {
    func didSelectEpisode(rmEpisodeListView: RMEpisodeListView) {
        viewModel.didSelectEpisode.sink { [weak self] episode in
            self?.rmRMEpisodeListView.send((rmEpisodeListView, episode))
        }.store(in: &cancellables)
    }

    func didLoadInitialEpisodes() {
        viewModel.didLoadInitialEpisodes.sink { [weak self] _ in
            self?.spinner.stopAnimating()
            self?.collectionView.isHidden = false
            self?.collectionView.reloadData()
            UIView.animate(withDuration: 0.3, animations: {
                self?.collectionView.alpha = 1
            })
        }.store(in: &cancellables)
    }

    func didLoadMoreEpisodes() {
        viewModel.didLoadMoreEpisode.sink { [weak self] newIndexPath in
            self?.collectionView.performBatchUpdates {
                self?.collectionView.insertItems(at: newIndexPath)
            }
        }.store(in: &cancellables)
    }
}
