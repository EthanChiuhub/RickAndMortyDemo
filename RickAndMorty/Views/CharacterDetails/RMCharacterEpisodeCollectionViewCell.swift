//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2023/8/15.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "RMCharacterEpisodeCollectionViewCell"
    
    private let seasonLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .regular)
        return label
    }()
    
    private let airDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()

    
     // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        setUpLayer()
        contentView.addSubviews(seasonLabel, nameLabel, airDateLabel)
        setUpConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
    
    private func setUpLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
    }

    private func setUpConstraints() {
        
        seasonLabel.snp.makeConstraints { make in
            make.top.right.equalTo(contentView)
            make.left.equalTo(contentView).offset(10)
            make.height.equalTo(contentView).multipliedBy(0.3)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(seasonLabel.snp.bottom)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView)
            make.height.equalTo(contentView).multipliedBy(0.3)
        }
        
        airDateLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalTo(contentView).offset(10)
            make.right.equalTo(contentView)
            make.height.equalTo(contentView).multipliedBy(0.3)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }

    public func configer(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {
        viewModel.registerForData { [weak self] data in
            self?.nameLabel.text = data.name
            self?.seasonLabel.text = "Episode "+data.episode
            self?.airDateLabel.text = "Aired on "+data.airdate
        }
        viewModel.fetchEpisode()
        contentView.layer.borderColor = viewModel.borderColor.cgColor
    }
}
