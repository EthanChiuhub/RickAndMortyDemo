//
//  RMSearchInputView.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/3/3.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
}

final class RMSearchInputView: UIView {
    
    weak var delegate: RMSearchInputViewDelegate?
    
    private let searchBar: UISearchBar = {
        let searBar = UISearchBar()
        searBar.placeholder = "Search"
        return searBar
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            let option = viewModel.option
            createOptionSelectionViews(option: option)
        }
    }
    
    private var stackView: UIStackView?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(searchBar)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    private func addConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self)
            make.left.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(58)
        }
    }
    
    private func createOptionSelectionViews(option: [RMSearchInputViewViewModel.DynamicOption]) {
        let stackView = createOptionStackView()
        self.stackView = stackView
        for x in 0..<option.count {
            let option = option[x]
            let button = createButton(with: option, tag: x)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createButton(
        with option: RMSearchInputViewViewModel.DynamicOption,
        tag: Int) -> UIButton {
            let button = UIButton()
            button.setAttributedTitle(NSAttributedString(
                string: option.rawValue,
                attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                             .foregroundColor: UIColor.label]),
                                      for: .normal)
            button.setTitle(option.rawValue, for: .normal)
            button.backgroundColor = .secondarySystemBackground
            button.setTitleColor(.label, for: .normal)
            button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
            button.tag = tag
            button.layer.cornerRadius = 6
            return button
        }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.option else {
            return
        }
        let tag = sender.tag
        let selected = options[tag]
        delegate?.rmSearchInputView(self, didSelectOption: selected)
    }
    
    
    
    private func createOptionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 6
        stackView.alignment = .center
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalTo(self)
        }
        
        return stackView
    }
    
    // MARK: - Public
    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
#warning(" TODO: Fix height of input view for episode with no options")
        self.viewModel = viewModel
    }
    
    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    public func update(
        option: RMSearchInputViewViewModel.DynamicOption,
        value: String
    ) {
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let allOptions = viewModel?.option,
              let index = allOptions.firstIndex(of: option) else {
            return
        }
        let button: UIButton = buttons[index]
        button.setAttributedTitle(
            NSAttributedString(
                string: value.uppercased(),
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.link
                ]
            ),
            for: .normal)
    }
}
