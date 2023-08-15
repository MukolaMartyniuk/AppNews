//
//  NewsDetailView.swift
//  AppNews
//
//  Created by Микола on 12.08.2023.
//

import SwiftUI

struct NewsDetailView: View {
    
    let article: Article
    
    @State private var searchQuery: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    TextField("Search", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                if let imageURL = article.urlToImage, let url = URL(string: imageURL), let imageData = try? Data(contentsOf: url), let image = UIImage(data: imageData) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 200)
                }
                
                hilightedText(str: article.title, searched: searchQuery)
                    .multilineTextAlignment(.leading)
                    .font(.title)
                    .padding()
                
                hilightedText(str: article.description ?? "", searched: searchQuery)
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .padding()
                
                hilightedText(str: "Author: \(article.author ?? "Unknown")", searched: searchQuery)
                    .multilineTextAlignment(.leading)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
                
                hilightedText(str: "Source: \(article.source.name)", searched: searchQuery)
                    .multilineTextAlignment(.leading)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
                
                hilightedText(str: "Published at: \(article.publishedAt)", searched: searchQuery)
                    .multilineTextAlignment(.leading)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding()
            }
            .navigationBarTitle("News Detail")
        }
    }
    
    func hilightedText(str: String, searched: String) -> Text {
        guard !str.isEmpty && !searched.isEmpty else { return Text(str) }
        
        var result: Text!
        let parts = str.components(separatedBy: searched)
        for i in parts.indices {
            result = (result == nil ? Text(parts[i]) : result + Text(parts[i]))
            if i != parts.count - 1 {
                result = result + Text(searched).bold().foregroundColor(.green)
            }
        }
        return result ?? Text(str)
    }
}


