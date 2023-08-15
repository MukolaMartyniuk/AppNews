//
//  ArticleFetcher.swift
//  AppNews
//
//  Created by Микола on 14.08.2023.
//

import Foundation


class ArticleFetcher {
    
    static let shared = ArticleFetcher()
    
    func fetchArticles(completion: @escaping ([Article]?) -> Void) {
        let urlString = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=9b288b638adb4cc2af5bcf84b7004222"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let articleResponse = try decoder.decode(ArticleResponse.self, from: data)
                completion(articleResponse.articles)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
