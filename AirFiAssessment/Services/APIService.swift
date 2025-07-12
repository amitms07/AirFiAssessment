//
//  APIService.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 10/07/25.
//
import Foundation


protocol APIServiceProtocol {
    func fetchArticleIDs(completion: @escaping ([String]) -> Void)
    func fetchArticle(by id: String, completion: @escaping (ArticleModel) -> Void)
    func updateArticles(_ articles: [ArticleModel], completion: @escaping (Bool) -> Void)
}


class APIService: APIServiceProtocol {


    private var articlesDatabase: [String: ArticleModel] = [
        "a1": ArticleModel(
            id: "a1",
            title: "Market Trends",
            description: "Markets up by 2% today...",
            author: "Robert",
            version: 1,
            fullContent: "The stock market saw a rise of 2% today, led by gains in IT and Pharma sectors.",
            approvedBy: []),
        
        "a2": ArticleModel(
            id: "a2",
            title: "Weather Update",
            description: "Heavy rain forecasted in Delhi...",
            author: "Robert",
            version: 1,
            fullContent: "The meteorological department has issued a warning for heavy rainfall in coastal areas.",
            approvedBy: []),
        
        "a3": ArticleModel(
            id: "a3",
            title: "Election Results",
            description: "New party wins majority wjdhsbf ijfb sdjfb sdjfb sdjb...",
            author: "Robert",
            version: 1,
            fullContent: "In a surprising turn of events, the new political party secured a majority in the elections.",
            approvedBy: []),
        
        "a4": ArticleModel(
            id: "a4",
            title: "Tech Launch",
            description: "New iPhone unveiled today...",
            author: "Alice",
            version: 1,
            fullContent: "Apple has unveiled its latest iPhone model with new AI features.",
            approvedBy: []),
        
        "a5": ArticleModel(
            id: "a5",
            title: "Sports Recap",
            description: "Team A wins championship...",
            author: "Alice",
            version: 1,
            fullContent: "Team A won the championship in a nail-biting final match last night.",
            approvedBy: []),
        
        "a6": ArticleModel(
            id: "a6",
            title: "Health Alert",
            description: "Rise in flu cases reported...",
            author: "Alice",
            version: 1,
            fullContent: "Doctors have reported a rise in flu cases in urban areas. Precautions are advised.",
            approvedBy: []),
        
        "a7": ArticleModel(
            id: "a7",
            title: "Tech Hiring Freeze",
            description: "Major layoffs in tech...",
            author: "John",
            version: 1,
            fullContent: "Several tech companies announced hiring freezes and layoffs due to market downturns.",
            approvedBy: []),
        
        "a8": ArticleModel(
            id: "a8",
            title: "Hii ",
            description: "Major layoffs in tech...",
            author: "John",
            version: 1,
            fullContent: "Several tech companies announced hiring freezes and layoffs due to market downturns.",
            approvedBy: [])
    ]

  

    func fetchArticleIDs(completion: @escaping ([String]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let ids = Array(self.articlesDatabase.keys)
            completion(ids)
        }
    }

    func fetchArticle(by id: String, completion: @escaping (ArticleModel) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if let article = self.articlesDatabase[id] {
                completion(article)
            } else {
                completion(ArticleModel(
                    id: id,
                    title: "Unknown",
                    description: "No data",
                    author: "Unknown",
                    version: 1,
                    fullContent: "No content found",
                    approvedBy: []
                ))
            }
        }
    }

    func updateArticles(_ articles: [ArticleModel], completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            for article in articles {
                self.articlesDatabase[article.id] = article
            }
            print("✅ Updated articles (mocked PUT):")
            for article in articles {
                print("• \(article.id): approvedBy = \(article.approvedBy)")
            }
            completion(true)
        }
    }
}
