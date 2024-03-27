//
//  RMSearchView.swift
//  RickAndMorty
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
    
    private let resultsView = RMSearchResultsView()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubviews(resultsView, noResultsView, searchInputView)
        addConstraint()
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        
        setUpHandlers()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpHandlers() {
        viewModel.registerOptionChangeBlock { tuple in
            // tuple: Option | newValue
            print(String(describing: tuple))
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        viewModel.reqisterSearchResultHander { [weak self] results in
            DispatchQueue.main.async { [weak self] in
                self?.resultsView.configure(with: results)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        viewModel.reqisterNoResultHander {
            DispatchQueue.main.async { [weak self] in
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
    
    private func addConstraint() {
        searchInputView.snp.makeConstraints { make in
            make.top.left.right.equalTo(self)
            make.height.equalTo(viewModel.config.type == .episode ? 55 : 110)
        }
        
        resultsView.snp.makeConstraints { make in
            make.top.equalTo(searchInputView.snp.bottom)
            make.left.right.bottom.equalTo(self)
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
    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
}
