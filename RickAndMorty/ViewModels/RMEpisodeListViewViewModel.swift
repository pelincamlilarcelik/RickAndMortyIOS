//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 27.02.2023.
//

import Foundation
import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject{
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}
/// View Model to handle episode list view logic
final class RMEpisodeListViewViewModel: NSObject{
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreEpisodes = false
    
    private let borderColors: [UIColor] = [
        .systemBlue,
        .systemGreen,
        .systemYellow,
        .systemPurple,
        .systemPink,
        .systemRed,
        .systemOrange,
        .systemMint,
        .systemIndigo
        
        
    ]
    
    private var episodes: [RMEpisode] = []{
        didSet{
            
            for episode in episodes{
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url),
                    borderColor: borderColors.randomElement() ?? .systemBlue
                )
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
                
            }
        }
    }
    private var cellViewModels : [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    
    /// Fetch initial set of characters (20)
    func fetchEpisodes(){
        RMService.shared.execute(.listEpisodeRequest, expecting: RMGetAllEpisodesResponse.self) {[weak self] result in
            switch result{
                
            case .success(let responseModel):
                DispatchQueue.main.async {
                    let info = responseModel.info
                    self?.apiInfo = info
                    self?.episodes = responseModel.results
                    self?.delegate?.didLoadInitialEpisodes()
                }
               
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    /// Paginate if additional characters if needed
    public func fetchAdditionalEpisodes(url: URL){
        guard !isLoadingMoreEpisodes else {
            return
        }
        isLoadingMoreEpisodes = true
        
        guard let request = RMRequest(url: url) else {
            //isLoadingMoreCharacters = false
            print("Failed to create request")
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMGetAllEpisodesResponse.self) { [weak self]result in
            guard let self = self else {return}
            switch result{
                
            case .success(let responseModel):
                let info = responseModel.info
                let moreResults = responseModel.results
                self.apiInfo = info
                
                let originalCount = self.episodes.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                print(indexPathToAdd)
                
                self.episodes.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreEpisodes(with: indexPathToAdd)
                    self.isLoadingMoreEpisodes = false
                }
                
            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMoreEpisodes = false
            }
        }
    }
    public var shouldShowLoadMoreIndicator: Bool{
        return  apiInfo?.next != nil
    }
}
// MARK: CollectionView
extension RMEpisodeListViewViewModel: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as?  RMCharacterEpisodeCollectionViewCell else{return UICollectionViewCell()}
        let viewModel = cellViewModels[indexPath.row]
        
        cell.configure(with: viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,shouldShowLoadMoreIndicator else {
            fatalError("Unsupported")
        }
        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath) as? RMFooterLoadingCollectionReusableView else{
            return UICollectionReusableView()
        }
        footer.startAnimating()
        return footer
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-20)
        return CGSize(width: width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
    
    
}
extension RMEpisodeListViewViewModel: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes,
              let nextStringUrl = apiInfo?.next,
              !cellViewModels.isEmpty,
              let url = URL(string: nextStringUrl)
        else{
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) {[weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollVieFixedHeight = scrollView.frame.size.height
            if offset >= (totalContentHeight-totalScrollVieFixedHeight-120){
                self?.fetchAdditionalEpisodes(url: url)
                
            }
            t.invalidate()
        }
    }
}
