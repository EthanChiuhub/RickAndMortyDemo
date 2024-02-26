//
//  RMLocationViewController.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/19.
//

import UIKit

/// Controller to show and search for Location
final class RMLocationViewController: UIViewController, RMLocationViewModelDeleagate, RMLocationViewDeleage {
    
    private let primaryView = RMLocationView()
    
    private let viewModel = RMLocationViewModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        primaryView.delegate = self
        view.backgroundColor = .systemBackground
        view.addSubview(primaryView)
        title = "Locations"
        addSearchButton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: .init(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - LocationViewModel Delegate
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
    
    // MARK: - LocationViewDelegate

    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
