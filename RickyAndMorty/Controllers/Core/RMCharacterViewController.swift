//
//  RMCharacterViewController.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/19.
//

import Combine
import UIKit

/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {
    private let characterListView = RMCharacterListView()

    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setupView()
        rmCHaracterListView()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: RMSearchViewController.Config(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    private func setupView() {
        view.addSubview(characterListView)
        characterListView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - RMCharacterListView Combine function

    func rmCHaracterListView() {
        // Open detail controller for that character
        characterListView.rmCharacterListView
            .sink { [weak self] _, rmCharacter in
                let viewModel = RMCharacterDetailViewViewModel(character: rmCharacter)
                let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
                detailVC.navigationItem.largeTitleDisplayMode = .never
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }.store(in: &cancellables)
    }
}
