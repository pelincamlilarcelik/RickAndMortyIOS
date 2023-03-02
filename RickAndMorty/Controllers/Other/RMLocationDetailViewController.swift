//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import UIKit

final class RMLocationDetailViewController: UIViewController ,RMLocationDetailViewViewModelDelegate, RMLocationDetailViewDelegate {
    
    
   
    
    func rmLocationDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didFetchEpisodeDetails() {
        locationDetailView.configure(with: viewModel)
    }
    
    
    private let viewModel: RMLocationDetailViewViewModel
    private let locationDetailView = RMLocationDetailView()
    
    init(location:RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = .init(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        view.backgroundColor = .systemBackground
        view.addSubview(locationDetailView)
        locationDetailView.delegate = self
        viewModel.delegate = self
        viewModel.fetchLocationData()
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action:#selector(didTapShare))
    }
    @objc private func didTapShare(){
        
    }
    
    private func addConstraints(){
        NSLayoutConstraint.activate([
            locationDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationDetailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            locationDetailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            locationDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

        ])
    }
    func didFetchLocationDetails() {
        locationDetailView.configure(with: viewModel)
    }

}
