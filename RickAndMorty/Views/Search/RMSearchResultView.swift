//
//  RMSearchResultView.swift
//  RickAndMorty
//
//  Created by Onur Celik on 5.03.2023.
//

import UIKit
protocol RMSearchResultViewDelegate: AnyObject{
    func rmSearchResultView(_ resultsView:RMSearchResultView,didTapLocationAt index: Int)
}

/// Show search result UI
final class RMSearchResultView: UIView {
    weak var delegate: RMSearchResultViewDelegate?

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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        return collectionView
    }()
    
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    
    private var collectionViewCellViewModels: [any Hashable] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(tableView,collectionView
        )
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
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .episodes(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .locations(let viewModels):
            
            setUpTableView(viewModels: viewModels)
        }
    }
    private func setUpCollectionView(){
        self.tableView.isHidden = true
        self.collectionView.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]){
       
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        collectionView.isHidden = true
        self.locationCellViewModels = viewModels
        tableView.reloadData()
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    public func configure(with viewModel: RMSearchResultViewModel){
        self.viewModel = viewModel
    }
}
extension RMSearchResultView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as?
                RMLocationTableViewCell else{
            fatalError("Failed to dequeue RMLocationTableViewCell")
        }
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultView(self, didTapLocationAt: indexPath.row)
    }
    
}
extension RMSearchResultView: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentVM = collectionViewCellViewModels[indexPath.row]
        if let characterVM =  currentVM as? RMCharacterCollectionViewCellViewModel{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else {fatalError()}
            cell.configure(with: characterVM)
           return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {fatalError()}
        if let episodeVM = currentVM as? RMCharacterEpisodeCollectionViewCellViewModel{
            cell.configure(with: episodeVM)
        }
       return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentVM = collectionViewCellViewModels[indexPath.row]
        let bounds = collectionView.bounds
        if currentVM is RMCharacterCollectionViewCellViewModel{
            let width = (bounds.width-30)/2
            return CGSize(width: width, height: width*1.5)
            
        }
        let width = bounds.width-20
        return CGSize(width: width, height: 100)
    }
    
}
