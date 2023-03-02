//
//  RMNoSearchResultsView.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import UIKit

final class RMNoSearchResultsView: UIView {
    private let viewModel = RMNoSearchResultsViewViewModel()
    
    private let iconImage: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFit
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.tintColor = .systemBlue
        return icon
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(iconImage,label)
        addConstraints()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            iconImage.widthAnchor.constraint(equalToConstant: 90),
            iconImage.heightAnchor.constraint(equalToConstant: 90),
            iconImage.topAnchor.constraint(equalTo: topAnchor),
            iconImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.topAnchor.constraint(equalTo: iconImage.bottomAnchor,constant: 10),
            
        ])
    }
    private func configure(){
        label.text = viewModel.title
        iconImage.image = viewModel.image
    }
    
}
