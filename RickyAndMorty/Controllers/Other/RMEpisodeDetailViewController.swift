//
//  RMEpisodeDetailViewController.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/16.
//

import UIKit

/// VC to show details about single episode
class RMEpisodeDetailViewController: UIViewController {
        
    private let viewModel: RMEpisodeDetailViewViewModel
    
 // MARK: - Init
    init(url: URL?) {
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
     // MARK: - Lify cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemGreen
    }
}
