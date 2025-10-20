//
//  CoreDataManager.swift
//  ReaderApp
//
//  Created by Sambhav Oraon on 19/10/25.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext) {
        self.context = context
    }
    
    func saveArticle(_ apiAriticles: [AritcleAPIModel]) {
        for apiAriticle in apiAriticles {
            let fetchRequest: NSFetchRequest<Article> = Article .fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "url == %@", apiAriticle.url)
            if let existing = try? context.fetch(fetchRequest).first {
                update(existing, with: apiAriticle)
            } else {
                let newArticle = Article(context: context)
                update(newArticle, with: apiAriticle)
            }
        }
        saveContext()
    }
    
    private func update(_ article: Article, with apiArticle: AritcleAPIModel) {
        article.title = apiArticle.title
        article.author = apiArticle.author
        article.newsDescription = apiArticle.description
        article.url = apiArticle.url
        article.urlToImage = apiArticle.urlToImage
        if let dateString = apiArticle.publishedAt {
            article.publishedAt = ISO8601DateFormatter().date(from: dateString)
        }
    }
    
    func fetchCachedAritcles() -> [Article] {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
        return (try? context.fetch(fetchRequest)) ?? []
    }
    
    func bookmarkArticle(_ article: Article, isBookmarked: Bool) {
        article.isBookmarked = isBookmarked
        saveContext()
    }
    
    func  fetchBookmarkedArticles() -> [Article] {
        let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isBookmarked == true")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: true)]
        return (try? context.fetch(fetchRequest)) ?? []
    }
    
    private func saveContext() {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
