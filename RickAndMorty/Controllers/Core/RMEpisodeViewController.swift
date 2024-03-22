//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/19.
//

import UIKit
import Combine

/// Controller to show and search for Episode
final class RMEpisodeViewController: UIViewController {
    
    private let episodeListView = RMEpisodeListView()

    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setupView()
        rmEpisodeListView()
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }


    private func setupView() {
        view.addSubview(episodeListView)
        
        episodeListView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    // MARK: - RMEpisodeListView Combine function

    func rmEpisodeListView() {
        // Open detail controller for that episode
        episodeListView.rmRMEpisodeListView
            .sink { [weak self] _, rmEpisode in
                let detailVC = RMEpisodeDetailViewController(url: URL(string: rmEpisode.url))
                detailVC.navigationItem.largeTitleDisplayMode = .never
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }.store(in: &cancellables)
    }
}
