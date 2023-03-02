//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by Onur Celik on 23.02.2023.
//

import UIKit

final class RMLocationViewController: UIViewController, RMLocationViewModelDelegate, RMLocationViewDelegate {
    
    
    private let primaryView = RMLocationView()
    
    private let viewModel = RMLocationViewModel()
    
    
   // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        primaryView.delegate = self
        view.addSubviews(primaryView)
        view.backgroundColor = .systemBackground
        title = "Locations"
        addSearchButton()
        addConstraints()
        viewModel.delegate = self
        viewModel.fetchLocations()

    }
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search,
                                                            target: self,
                                                            action:#selector(didTapSearch))
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            primaryView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    @objc private func didTapSearch(){
        
    }

    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    

}
