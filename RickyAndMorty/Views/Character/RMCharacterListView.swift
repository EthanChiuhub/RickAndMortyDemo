//
//  RMCharacterListView.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/31.
//

import Combine
import UIKit

/// View that handles showing list of characters. loader. etc
final class RMCharacterListView: UIView {
    var cancellables = Set<AnyCancellable>()
    
    private let viewModel = RMCharacterListViewViewModel()
    
    public let rmCharacterListView = PassthroughSubject<(RMCharacterListView,
                                                         RMCharacter), Never>()
    
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
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
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
        viewModel.fetchCharacters()
        setUpCollectionView()
        subscribeEvent()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Unsupported")
    }
    
    /// Subscribe ViewModel event
    private func subscribeEvent() {
        didLoadInitialCharacters()
        didLoadMoreCharacter()
        didSelectCharacter(rmCHaracterListView: self)
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

extension RMCharacterListView {
    func didSelectCharacter(rmCHaracterListView: RMCharacterListView) {
        viewModel.didSelectCharacter.sink { [weak self] character in
            self?.rmCharacterListView.send((rmCHaracterListView, character))
        }.store(in: &cancellables)
    }
    
    func didLoadInitialCharacters() {
        viewModel.didLoadInitialCharacters.sink { [weak self] _ in
            self?.spinner.stopAnimating()
            self?.collectionView.isHidden = false
            self?.collectionView.reloadData()
            UIView.animate(withDuration: 0.3, animations: {
                self?.collectionView.alpha = 1
            })
        }.store(in: &cancellables)
    }
    
    func didLoadMoreCharacter() {
        viewModel.didLoadMoreCharacter.sink { [weak self] newIndexPath in
            self?.collectionView.performBatchUpdates {
                self?.collectionView.insertItems(at: newIndexPath)
            }
        }.store(in: &cancellables)
    }
}
