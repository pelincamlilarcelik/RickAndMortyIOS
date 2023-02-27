//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 24.02.2023.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject{
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectCharacter(_ character: RMCharacter)
}
/// View Model to handle character list view logic
final class RMCharacterListViewViewModel: NSObject{
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    private var characters: [RMCharacter] = []{
        didSet{
            
            for character in characters{
                let viewModel = RMCharacterCollectionViewCellViewModel(characterName: character.name,
                                                                       characterStatus: character.status,
                                                                       characterImageUrl: URL(string: character.image))
                if !cellViewModels.contains(viewModel){
                    cellViewModels.append(viewModel)
                }
                
            }
        }
    }
    private var cellViewModels : [RMCharacterCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    /// Fetch initial set of characters (20)
    func fetchCharacters(){
        RMService.shared.execute(.listCharacterRequest, expecting: RMGetAllCharactersResponse.self) {[weak self] result in
            switch result{
                
            case .success(let responseModel):
                DispatchQueue.main.async {
                    let info = responseModel.info
                    self?.apiInfo = info
                    self?.characters = responseModel.results
                    self?.delegate?.didLoadInitialCharacters()
                }
               
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    /// Paginate if additional characters if needed
    public func fetchAdditionalCharacters(url: URL){
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
        
        guard let request = RMRequest(url: url) else {
            //isLoadingMoreCharacters = false
            print("Failed to create request")
            return
        }
        RMService.shared.execute(request,
                                 expecting: RMGetAllCharactersResponse.self) { [weak self]result in
            guard let self = self else {return}
            switch result{
                
            case .success(let responseModel):
                let info = responseModel.info
                let moreResults = responseModel.results
                self.apiInfo = info
                
                let originalCount = self.characters.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(row: $0, section: 0)
                })
                print(indexPathToAdd)
                
                self.characters.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    self.delegate?.didLoadMoreCharacters(with: indexPathToAdd)
                    self.isLoadingMoreCharacters = false
                }
                
            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMoreCharacters = false
            }
        }
    }
    public var shouldShowLoadMoreIndicator: Bool{
        return  apiInfo?.next != nil
    }
}
// MARK: CollectionView
extension RMCharacterListViewViewModel: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterCollectionViewCell.celIdentifier, for: indexPath) as?  RMCharacterCollectionViewCell else{return UICollectionViewCell()}
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
        let width = (bounds.width-30)/2
        return CGSize(width: width, height: width*1.5)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
    }
    
    
}
extension RMCharacterListViewViewModel: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
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
                self?.fetchAdditionalCharacters(url: url)
                
            }
            t.invalidate()
        }
    }
}
