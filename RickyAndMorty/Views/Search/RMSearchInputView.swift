//
//  RMSearchInputView.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/3/3.
//

import UIKit

final class RMSearchInputView: UIView {
    private let viewModel: RMSearchInputViewViewModel
    
     init(frame: CGRect, viewModel: RMSearchInputViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
