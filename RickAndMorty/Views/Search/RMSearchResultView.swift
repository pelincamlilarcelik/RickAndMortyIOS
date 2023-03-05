//
//  RMSearchResultView.swift
//  RickAndMorty
//
//  Created by Onur Celik on 5.03.2023.
//

import UIKit
/// Show search result UI
final class RMSearchResultView: UIView {

    private var viewModel: RMSearchResultViewModel?{
        didSet{
            processViewModel()
        }
    }
    private let tableView: UITableView = {
      let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        table.isHidden = true
        return table
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(tableView)
        addConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    func processViewModel(){
        guard let viewModel = viewModel else{
            return
        }
        switch viewModel{
            
        case .characters(let viewModels):
            setUpCollectionView()
        case .episodes(let viewModels):
            setUpTableView()
        case .locations(let viewModels):
            setUpCollectionView()
        }
    }
    private func setUpCollectionView(){
        
    }
    private func setUpTableView(){
        tableView.isHidden = false
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    public func configure(with viewModel: RMSearchResultViewModel){
        self.viewModel = viewModel
    }
}
