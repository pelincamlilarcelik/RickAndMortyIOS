//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import UIKit
protocol RMSearchViewDelegate: AnyObject{
    func rmSearchView(_ searchView: RMSearchView,didSelectOption option: RMSearchInputViewViewModel.DynamicType)
}

final class RMSearchView: UIView {
    weak var delegate: RMSearchViewDelegate?
    private let viewModel: RMSearchViewViewModel
    
    private let noResultsView = RMNoSearchResultsView()
    
    private let searchInputView = RMSearchInputView()
    
     init(frame: CGRect,viewModel: RMSearchViewViewModel) {
         self.viewModel = viewModel
         super.init(frame: frame)
         backgroundColor = .systemBackground
         translatesAutoresizingMaskIntoConstraints = false
         addSubviews(noResultsView,searchInputView)
         addConstraints()
         searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
         searchInputView.delegate = self
         viewModel.registerOptionChangeBlock{tuple in
             self.searchInputView.update(option: tuple.0, value: tuple.1)
         }
         viewModel.registerSearchResultHandler {
             
         }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            // search input
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            // No results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    public func presentKeyboard(){
        searchInputView.presentKeyboard()
    }
    
}
extension RMSearchView: UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
extension RMSearchView: RMSearchInputViewDelegate{
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicType) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearhText text: String) {
        viewModel.set(query: text)
    }
    func rmSearchInputViewDidTapKeyboardSearchButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}
