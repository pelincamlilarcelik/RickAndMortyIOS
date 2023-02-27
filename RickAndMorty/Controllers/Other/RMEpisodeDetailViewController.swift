//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Onur Celik on 27.02.2023.
//

import UIKit
/// VC to show details about single episode
final class RMEpisodeDetailViewController: UIViewController {
    private let url: URL?
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemBackground
    }
    

   

}
