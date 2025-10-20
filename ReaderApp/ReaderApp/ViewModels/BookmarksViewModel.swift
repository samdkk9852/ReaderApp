//
//  BookmarksViewModel.swift
//  ReaderApp
//
//  Created by Sambhav Oraon on 19/10/25.
//

import Foundation

class BookmarksViewModel {
    var bookmarkedArticles: [Article] = []
    
    func loadBookmarks() {
        bookmarkedArticles = CoreDataManager.shared.fetchBookmarkedArticles()
    }
}
