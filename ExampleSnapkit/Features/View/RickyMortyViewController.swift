//
//  RickyMortyViewController.swift
//  ExampleSnapkit
//
//  Created by mert can çifter on 1.11.2022.
//

import UIKit
import SnapKit


final class RickyMortyViewController: UIViewController {
    
    // MARK: Properties
    
    private var viewModel : RickyMortyViewModelProtocol! {
        didSet {
            viewModel.delegate = self
        }
    }
    
    private lazy var results: [Result] = []
    
    private let labelTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Ricky Morty"
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    private let indicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView()
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RickyMortyViewModel()
        viewModel.load()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        configureUI()
    }
    
    // MARK: Helpers
    
    private func configureUI(){
        view.addSubview(labelTitle)
        view.addSubview(tableView)
        view.addSubview(indicator)
        
        labelTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.height.greaterThanOrEqualTo(10)
        }
        
        indicator.snp.makeConstraints { make in
            make.height.equalTo(labelTitle)
            make.right.equalTo(labelTitle).offset(-5)
            make.top.equalTo(labelTitle)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(labelTitle.snp.bottom).offset(5)
            make.bottom.equalToSuperview()
            make.left.right.equalTo(labelTitle)
        }
    }
}

extension RickyMortyViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.results[indexPath.row].name ?? ""
        return cell
    }
}


extension RickyMortyViewController: RickyMortyViewModelDelegate {
    func handleViewModelOutput(_ output: RickyMortyViewModelOutput) {
        switch output {
        case .setLoading(let state):
            state ? indicator.startAnimating() : indicator.stopAnimating()
        case .success(let results):
            self.results = results
            self.tableView.reloadData()
        }
    }
}
