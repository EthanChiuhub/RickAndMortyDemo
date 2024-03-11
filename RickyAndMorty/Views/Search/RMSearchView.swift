//
//  RMSearchView.swift
//  RickyAndMorty
//
//  Created by Yi Chun Chiu on 2024/2/26.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
}

class RMSearchView: UIView {
    
    weak var delegate: RMSearchViewDelegate?
    
    private let viewModel: RMSearchViewViewModel
    
    private let noResultsView = RMNoSearchReslutView()
    
    private let searchInputView = RMSearchInputView()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews(noResultsView, searchInputView)
        addConstraint()
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        viewModel.registerOptionChangeBlock { tuple in
            // tuple: Option | newValue
            print(String(describing: tuple))
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstraint() {
        searchInputView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.height.equalTo(viewModel.config.type == .episode ? 55 : 110)
        }
        
        noResultsView.snp.makeConstraints { make in
            make.width.height.equalTo(150)
            make.centerX.centerY.equalTo(self)
        }
    }
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }

}

 // MARK: - Collection Delegate
extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
}

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
}
