//
//  RMSearchInputView.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import UIKit
protocol RMSearchInputViewDelegate: AnyObject{
    func rmSearchInputView(_ inputView: RMSearchInputView,
                           didSelectOption option: RMSearchInputViewViewModel.DynamicType  )
    
    func rmSearchInputView(_ inputView: RMSearchInputView,
                           didChangeSearhText text: String  )
    func rmSearchInputViewDidTapKeyboardSearchButton(_ inputView: RMSearchInputView)
    
}
/// View for top part of search screen with search bar
final class RMSearchInputView: UIView {
    weak var delegate: RMSearchInputViewDelegate?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search"
        return searchBar
  }()
    
    private var viewModel: RMSearchInputViewViewModel?{
        didSet{
            guard let viewModel = viewModel,viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
            createOptionSelectionViews(options:options)
        }
    }
    private var stackView: UIStackView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(searchBar)
        addConstraints()
        searchBar.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
     func configure(with viewModel: RMSearchInputViewViewModel){
        searchBar.placeholder = viewModel.searchPlaceholder
         self.viewModel = viewModel
    }
    private func createOptionStackView()-> UIStackView{
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        return stackView
    }
    private func createButton(with option: RMSearchInputViewViewModel.DynamicType,tag:Int)->UIButton{
        let button = UIButton()
        button.setAttributedTitle(NSAttributedString(
            string: option.rawValue,
            attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                         .foregroundColor: UIColor.label]), for: .normal)
        button.backgroundColor = .secondarySystemBackground
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 6
        return button
    }
    private func createOptionSelectionViews(options:[RMSearchInputViewViewModel.DynamicType]){
        let stackView = createOptionStackView()
        self.stackView = stackView
        for x in 0..<options.count{
            let option = options[x]
            let button = createButton(with: option, tag: x)
            stackView.addArrangedSubview(button)
        }
    }
    @objc private func didTapButton(_ sender: UIButton){
        guard let options = viewModel?.options else {return}
        let tag = sender.tag
        let option = options[tag]
        delegate?.rmSearchInputView(self, didSelectOption: option)
    }
    public func presentKeyboard(){
        searchBar.becomeFirstResponder()
    }
    public func update(option: RMSearchInputViewViewModel.DynamicType,value:String){
        // update options
        guard let buttons = stackView?.arrangedSubviews as? [UIButton],
              let options = viewModel?.options else{
            return
        }
        guard let index = options.firstIndex(of: option)else{
            return
        }
        buttons[index].setAttributedTitle(NSAttributedString(
            string: value.uppercased(),
            attributes: [.font: UIFont.systemFont(ofSize: 18, weight: .medium),
                         .foregroundColor: UIColor.link]), for: .normal)
        
    }
}
extension RMSearchInputView: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.rmSearchInputView(self, didChangeSearhText: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        delegate?.rmSearchInputViewDidTapKeyboardSearchButton(self)
    }
}
