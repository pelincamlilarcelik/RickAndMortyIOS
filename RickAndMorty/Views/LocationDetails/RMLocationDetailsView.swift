//
//  RMLocationDetailsView.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import UIKit

protocol RMLocationDetailViewDelegate: AnyObject{
    func rmLocationDetailView(
        _ detailView:RMLocationDetailView,
        didSelect character: RMCharacter)
}

final class RMLocationDetailView: UIView {
    
    public weak var delegate: RMLocationDetailViewDelegate?
    
    private var viewModel: RMLocationDetailViewViewModel?{
        didSet{
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3){
                self.collectionView?.alpha = 1
            }
            
        }
    }
    
    private var collectionView: UICollectionView?
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        self.collectionView = createCollectionView()
        addSubview(spinner)
        addConstraints()
        spinner.startAnimating()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstraints(){
        guard let collectionView = collectionView  else {return}
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    func configure(with viewModel: RMLocationDetailViewViewModel){
        self.viewModel = viewModel
    }
    private func createCollectionView()->UICollectionView{
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layout(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        collectionView.register(RMEpisodeInfoCollectionViewCell.self, forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.alpha = 0
        return collectionView
    }
}
extension RMLocationDetailView: UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else {return 0}
        let sectionType = sections[section]
        switch sectionType{
        case .characters(let viewModels):
            return viewModels.count
        case .information(let viewModels):
            return viewModels.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.cellViewModels else { fatalError("No Viewmodel")}
        let sectionType = sections[indexPath.section]
        switch sectionType{
        case .characters(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.configure(with: cellViewModel)
            
            return cell
        case .information(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier, for: indexPath) as? RMEpisodeInfoCollectionViewCell else{
                return UICollectionViewCell()
            }
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else {return}
        let sections = viewModel.cellViewModels
        let sectionType = sections[indexPath.section]
        switch sectionType{
        case .information:
            break
        case .characters:
            guard let character = viewModel.character(at:indexPath.row) else{
                return
            }
            delegate?.rmLocationDetailView(self, didSelect: character)
            
        }
        
        
    }
}
extension RMLocationDetailView{
    private func layout(for section: Int)->NSCollectionLayoutSection{
        guard let sections = viewModel?.cellViewModels else {
            return createInfoLayout()
        }
        switch sections[section]{
            
        case .information:
            return self.createInfoLayout()
        case .characters:
            return createCharacterLayout()
        }
    }
    func createInfoLayout()->NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)),
            subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
    func createCharacterLayout()->NSCollectionLayoutSection{
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .absolute(240)),
            repeatingSubitem: item,count: 2)
        return NSCollectionLayoutSection(group: group)
    }
}
