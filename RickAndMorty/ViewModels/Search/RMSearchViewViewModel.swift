//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import Foundation

// Responsibilities
// show search results
// show no result view
// API requests
final class RMSearchViewViewModel{
    let config: RMSearchViewController.Config
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
}
