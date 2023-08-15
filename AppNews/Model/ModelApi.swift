//
//  ModelApi.swift
//  AppNews
//
//  Created by Микола on 12.08.2023.
//

import Foundation

struct ArticleResponse: Codable {
    
    let status: String
    let totalResults: Int
    let articles: [Article]
    
}

struct Article: Codable {
    
    struct Source: Codable {
        let id: String?
        let name: String
    }
    
    
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
    
}
