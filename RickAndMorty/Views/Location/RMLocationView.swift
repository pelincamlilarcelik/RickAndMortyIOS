//
//  RMLocationView.swift
//  RickAndMorty
//
//  Created by Onur Celik on 2.03.2023.
//

import UIKit

class RMLocationView: UIView {
    
    private var viewModel: RMLocationViewModel?{
        didSet{
            spinner.stopAnimating()
            tableView.reloadData()
            tableView.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.tableView.alpha = 1
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.alpha = 0
        table.isHidden = true
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        return table
    }()
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView,spinner)
        backgroundColor = .systemBackground
        spinner.startAnimating()
        addConstraints()
        configureTable()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    private func  configureTable(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func addConstraints(){
        NSLayoutConstraint.activate([
            
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            
           
        ])
    }
    public func configure(with viewModel: RMLocationViewModel){
        self.viewModel = viewModel
    }
}
extension RMLocationView: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath) as? RMLocationTableViewCell else {
            fatalError()
        }
        guard let viewModel = viewModel else {fatalError()}
        let cellViewModel = viewModel.cellViewModels[indexPath.row]
        cell.textLabel?.text = cellViewModel.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //notify controller of selection
    }
}
