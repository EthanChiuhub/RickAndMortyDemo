//
//  RMNoSearchView.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/3/3.
//

import UIKit
import SnapKit

class RMNoSearchReslutView: UIView {
    
    private let viewModel = RMNoSearchResultsViewViewModel()
    
    private let iconView: UIImageView = {
       let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .systemBlue
        return iconView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(iconView, label)
        addConstraint()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        label.text = viewModel.title
        iconView.image = viewModel.image
    }
    
    private func addConstraint() {
        iconView.snp.makeConstraints { make in
            make.width.height.equalTo(90)
            make.top.equalTo(self)
            make.centerX.equalTo(self)
        }
        label.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(iconView.snp.bottom).offset(10)
        }
    }

}
