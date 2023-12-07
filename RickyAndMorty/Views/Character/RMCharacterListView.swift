//
//  RMCharacterListView.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/31.
//

import UIKit

protocol RMCharacterListViewDelegate: AnyObject {
    func rmCHaracterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter)
}

/// View that handles showing list of characters. loader. etc
final class RMCharacterListView: UIView {
    private let viewModel = RMCharacterListViewViewModel()

    public weak var delegate: RMCharacterListViewDelegate?

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
        viewModel.delegate = self
        viewModel.fetchCharacters()
        setUpCollectionView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Unsupported")
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    private func setUpCollectionView() {
        collectionView.dataSource = viewModel
        collectionView.delegate = viewModel
    }
}

extension RMCharacterListView: RMCharacterListViewViewModelDelegate {
    func didSelectCharacter(_ character: RMCharacter) {
        delegate?.rmCHaracterListView(self, didSelectCharacter: character)
    }

    func didLoadInitialCharacters() {
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData()
        UIView.animate(withDuration: 0.3, animations: {
            self.collectionView.alpha = 1
        })
    }

    func didLoadMoreCharacter(with newIndexPath: [IndexPath]) {
        collectionView.performBatchUpdates {
            self.collectionView.insertItems(at: newIndexPath)
        }
    }
}
