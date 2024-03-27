//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2024/3/27.
//

import UIKit

/// Shows search results UI (table or collection as needed)
class RMSearchResultsView: UIView {
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    private let tableView: UITableView = {
       let table = UITableView()
        table.register(RMLocationTableViewCell.self,
                       forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        table.isHidden = true
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        addSubview(tableView)
        translatesAutoresizingMaskIntoConstraints = false
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        switch viewModel {
        case .characters(let viewModels):
            setUpCollectionView()
        case .episodes(let viewModels):
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView()
        }
    }
    
    private func setUpCollectionView() {
        
    }
    
    private func setUpTableView() {
        tableView.isHidden = false
    }

    private func addConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
        tableView.backgroundColor = .blue
    }
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }

}
