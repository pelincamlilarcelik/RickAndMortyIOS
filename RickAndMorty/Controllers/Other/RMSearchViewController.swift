//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Onur Celik on 27.02.2023.
//

import UIKit
/// Configurable controller to search
final class RMSearchViewController: UIViewController {
    
    struct Config{
        enum `Type`{
            case character
            case episode
            case location
            
            var title: String{
                switch self{
                    
                case .character:// name status gender
                    return "Search Characters"
                case .episode:// name
                    return "Search Episodes"
                case .location: // name type
                    return "Search Locations"
                }
            }
        }
        let type: `Type`
    }
    private let viewModel: RMSearchViewViewModel
    
    private let searchView: RMSearchView
    
    init(config: Config) {
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubviews(searchView)
        addContraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapExecuteSearch))

        
    }
    @objc private func didTapExecuteSearch(){
        // viewModel.executeSearch()
    }
    private func addContraints(){
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

   

}
