//
//  NetworkServices.swift
//  ReaderApp
//
//  Created by Sambhav Oraon on 19/10/25.
//

import Foundation

class NetworkServices {
    static let shared = NetworkServices()
    private init () {}   // making it signleton class for global use case
    
    func fetchArticles(completion: @escaping (Result<[AritcleAPIModel], Error>) -> Void) {
        let urlString = "https://newsapi.org/v2/everything?q=tesla&from=2025-09-19&sortBy=publishedAt&apiKey=\(Constants.shared.APIKey)"
        
        guard let url = URL(string: urlString) else { return completion(.failure(NSError())) }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error { return completion(.failure(error)) }
            guard let data = data else { return completion(.failure(NSError())) }
            
            do {
                let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                completion(.success(response.articles))
            }catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
