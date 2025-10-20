//
//  BookmarkViewController.swift
//  ReaderApp
//
//  Created by Sambhav Oraon on 20/10/25.
//

import Foundation
import UIKit

class BookmarksViewController: UIViewController {
    private let tableView = UITableView()
    private let viewModel = BookmarksViewModel()
    private var bookmarkedArticles: [Article] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadBookmarks()
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleBookmarkChange), name: .bookmarkChanged, object: nil)
    }

    @objc private func handleBookmarkChange() {
        loadBookmarks()
    }
    
    private func setupUI() {
        title = "Bookmarks"
        view.backgroundColor = .systemBackground

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func loadBookmarks() {
        viewModel.loadBookmarks()
        bookmarkedArticles = viewModel.bookmarkedArticles
        tableView.reloadData()
    }
}

extension BookmarksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookmarkedArticles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        let article = bookmarkedArticles[indexPath.row]
        cell.configure(with: article, isBookmarked: article.isBookmarked) { [weak self] in
            guard let self = self else { return }
            CoreDataManager.shared.bookmarkArticle(article, isBookmarked: !article.isBookmarked)
            if !article.isBookmarked {
                if indexPath.row < bookmarkedArticles.count {
                    bookmarkedArticles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    loadBookmarks()
                }
            } else {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            //Notifiy the updated bookmark status to other viewcontroller
            NotificationCenter.default.post(name: .bookmarkChanged, object: nil)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
