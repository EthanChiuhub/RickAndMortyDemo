//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/8/15.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpConstraints() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configer(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        
    }
}
