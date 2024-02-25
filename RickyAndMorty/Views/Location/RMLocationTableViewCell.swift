//
//  RMLocationTableViewCell.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/25.
//

import UIKit

class RMLocationTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "RMLocationTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: RMLocationViewCellViewModel) {
        
    }

}
