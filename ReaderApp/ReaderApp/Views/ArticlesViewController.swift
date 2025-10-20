//
//  ArticlesViewController.swift
//  ReaderApp
//
//  Created by Sambhav Oraon on 20/10/25.
//

import Foundation
import UIKit

class ArticlesViewController: UIViewController {
    let tableView = UITableView()
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = ArticlesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    private func setupUI() {
        title = "Articles"
        view.backgroundColor = .systemBackground
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }
    
    @objc private func refreshData() {
        fetchData { self.refreshControl.endRefreshing() }
    }
    
    private func fetchData(completion: (() -> Void)? = nil) {
        viewModel.fetchArtciles { [weak self] in
            self?.tableView.reloadData()
            completion?()
        }
    }
}

extension ArticlesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.filteredArticles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        let article = viewModel.filteredArticles[indexPath.row]
        cell.configure(with: article, isBookmarked: article.isBookmarked) { [weak self] in
            //toggle bookmark
            print("Toggling bookmark for \(article.title)")
            CoreDataManager.shared.bookmarkArticle(article, isBookmarked: !article.isBookmarked)
            //refresh the UI
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}

extension ArticlesViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.filterArticles(with: searchController.searchBar.text ?? "")
        tableView.reloadData()
    }
}

