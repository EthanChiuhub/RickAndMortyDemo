//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Yi Chun Chiu on 2023/8/7.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "RMFooterLoadingCollectionReusableView"

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Unsupported")
    }

    private func addConstraints() {
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalTo(self)
        }
    }

    public func startAnimating() {
        spinner.startAnimating()
    }
}
