//
//  ArticlesViewModel.swift
//  ReaderApp
//
//  Created by Sambhav Oraon on 19/10/25.
//

import Foundation
import UIKit

class ArticlesViewModel {
    var articles: [Article] = []
    var filteredArticles: [Article] = []
    var isOffline: Bool = false
    
    func fetchArtciles(completion: @escaping () -> Void) {
        NetworkServices.shared.fetchArticles { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apiArticles):
                    CoreDataManager.shared.saveArticle(apiArticles)
                    self?.articles = CoreDataManager.shared.fetchCachedAritcles()
                    self?.isOffline = false
                    
                case .failure:
                    self?.articles = CoreDataManager.shared.fetchCachedAritcles()
                    self?.isOffline = true
                }
                self?.filteredArticles = self?.articles ?? []
                completion()
            }
        }
    }
    
    func filterArticles(with searchText: String) {
        if searchText.isEmpty {
            filteredArticles = articles
        } else {
            filteredArticles = articles.filter({ $0.title?.lowercased().contains(searchText.lowercased()) ?? false })
        }
    }
}
