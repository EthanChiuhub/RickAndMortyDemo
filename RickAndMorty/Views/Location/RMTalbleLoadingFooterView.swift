//
//  RMTalbleLoadingFooterView.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2024/3/29.
//

import UIKit

class RMTalbleLoadingFooterView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews(spinner)
        spinner.startAnimating()
        addConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstraints() {
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(55)
            make.centerX.centerY.equalToSuperview()
        }
    }
}
