//
//  RMCharacterInfoCollectionViewCell.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2023/8/15.
//

import UIKit

class RMCharacterInfoCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterInfoCollectionViewCell"

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }

    private func setUpConstraints() {}

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    public func configer(with _: RMCharacterInfoCollectionViewCellViewModel) {}
}
