//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/25.
//

import UIKit

final class RMLocationDetailViewController: UIViewController, RMLocationDetailViewDelegate, RMLocationDetailViewViewModelDeleagate {

    private let viewModel: RMLocationDetailViewViewModel

    private let detailView = RMLocationDetailView()

    // MARK: - Init

    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        addConstraints()
        detailView.delegate = self
        title = "Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))

        viewModel.delegate = self
        viewModel.fetchLocationData()
    }

    private func addConstraints() {
        detailView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    @objc
    private func didTapShare() {

    }

    // MARK: - View Delegate

    func rmEpisodeDetailView(
        _ detailView: RMLocationDetailView,
        didSelect character: RMCharacter
    ) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - ViewModel Delegate

    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
}
