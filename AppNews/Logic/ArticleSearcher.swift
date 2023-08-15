//
//  ArticleSearcher.swift
//  AppNews
//
//  Created by Микола on 14.08.2023.
//

import Foundation

class ArticleSearcher {
    
    static let shared = ArticleSearcher()
    
    func searchArticles(query: String, completion: @escaping ([Article]?) -> Void) {
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else {
            completion(nil)
            return
        }
        
        let urlString = "https://newsapi.org/v2/everything?q=\(trimmedQuery)&apiKey=9b288b638adb4cc2af5bcf84b7004222"
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
    
    
    func searchArticles(searchQuery: String, selectedTimePeriod: TimePeriod, completion: @escaping ([Article]?) -> Void) {
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return 
        }
        
        var fromDate: String = ""
        var toDate: String = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        switch selectedTimePeriod {
        case .day:
            let today = Date()
            fromDate = formatter.string(from: today)
            toDate = fromDate
        case .week:
            if let last7DaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) {
                fromDate = formatter.string(from: last7DaysAgo)
                toDate = formatter.string(from: Date())
            }
        case .month:
            if let last30DaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) {
                fromDate = formatter.string(from: last30DaysAgo)
                toDate = formatter.string(from: Date())
            }
        }
        
        let urlString = "https://newsapi.org/v2/everything?q=\(query)&from=\(fromDate)&to=\(toDate)&apiKey=9b288b638adb4cc2af5bcf84b7004222"
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let articleResponse = try decoder.decode(ArticleResponse.self, from: data)
                completion(articleResponse.articles)
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
}
