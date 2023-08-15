//
//  ContentView.swift
//  AppNews
//
//  Created by Микола on 12.08.2023.
//

import SwiftUI

enum TimePeriod: String, CaseIterable, Identifiable {
    
    case day = "1 Day"
    case week = "1 Week"
    case month = "1 Month"
       
    var id: String { self.rawValue }
    
}

struct ContentView: View {
    
    @State var articles: [Article] = []
    @State private var searchQuery: String = ""
    @State private var selectedTimePeriod: TimePeriod = .day
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $searchQuery)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button("Search") {
                        ArticleSearcher.shared.searchArticles(query: searchQuery) { fetchedArticles in
                            if let fetchedArticles = fetchedArticles {
                                self.articles = fetchedArticles
                            }
                        }
                    }
                }
                .padding()
                Picker("Time Period", selection: $selectedTimePeriod) {
                                    ForEach(TimePeriod.allCases, id: \.self) { period in
                                        Text(period.rawValue)
                                    }
                }.onReceive([self.selectedTimePeriod].publisher.first()){ value in
                    ArticleSearcher.shared.searchArticles(searchQuery: searchQuery, selectedTimePeriod: value) { fetchedArticles in
                        if let fetchedArticles = fetchedArticles {
                            self.articles = fetchedArticles
                        }
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                            
                List(articles, id: \.title) { article in
                    NavigationLink(destination: NewsDetailView(article: article)) {
                        VStack(alignment: .leading) {
                            Text(article.title)
                                .font(.headline)
                            Text(article.description ?? "")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("News")
            .onAppear {
                ArticleFetcher.shared.fetchArticles { fetchedArticles in
                    if let fetchedArticles = fetchedArticles {
                        self.articles = fetchedArticles
                    }
                }
            }
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
