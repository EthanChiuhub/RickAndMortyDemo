//
//  RMCharacterDetailViewController.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/8/7.
//

import UIKit

/// Controller to show info about single character
final class RMCharacterDetailViewController: UIViewController {
    private let viewModel: RMCharacterDetailViewViewModel
    private let detailView: RMCharacterDetailView

    // MARK: - Init

    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil,
                   bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShare)
        )
        addConstraints()
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }

    @objc
    func didTapShare() {
        // Share character info
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - CollectionView

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in _: UICollectionView) -> Int {
        return viewModel.sections.count
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType = viewModel.sections[section]
        switch sectionType {
        case .photo:
            return 1
        case let .infomation(viewModel):
            return viewModel.count
        case let .episodes(viewModel):
            return viewModel.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionType = viewModel.sections[indexPath.section]
        switch sectionType {
        case let .photo(viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterPhotoCollectionViewCell else { fatalError()
            }
            cell.backgroundColor = .systemYellow
            cell.configer(with: viewModel)
            return cell
        case let .infomation(viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterInfoCollectionViewCell else { fatalError()
            }
            cell.backgroundColor = .systemRed
            cell.configer(with: viewModel[indexPath.row])
            return cell
        case let .episodes(viewModel):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else { fatalError()
            }
            cell.backgroundColor = .systemOrange
            cell.configer(with: viewModel[indexPath.row])
            return cell
        }
    }
}
