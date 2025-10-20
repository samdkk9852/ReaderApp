//
//  AritcleAPIModel.swift
//  ReaderApp
//
//  Created by Sambhav Oraon on 19/10/25.
//

import Foundation

struct AritcleAPIModel: Codable {
    let title: String
    let author: String?
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String? // ISO date string
}

struct NewsResponse: Codable {
    let articles: [AritcleAPIModel]
}
