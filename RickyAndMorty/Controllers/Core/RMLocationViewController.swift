//
//  RMLocationViewController.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/7/19.
//

import UIKit

/// Controller to show and search for Location
final class RMLocationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchButton()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }
    
    @objc
    private func didTapSearch() {
        
    }

}
