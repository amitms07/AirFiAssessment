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
        "a1": ArticleModel(id: "a1", title: "Market Trends", description: "Markets up by 2% today...", author: "Robert", version: 1, fullContent: "The stock market saw a rise of 2% today, led by gains in IT and Pharma sectors.", approvedBy: []),
        "a2": ArticleModel(id: "a2", title: "Weather Update", description: "Heavy rain forecasted in Delhi...", author: "Robert", version: 1, fullContent: "The meteorological department has issued a warning for heavy rainfall in coastal areas.", approvedBy: []),
        "a3": ArticleModel(id: "a3", title: "Election Results", description: "New party wins majority...", author: "Robert", version: 1, fullContent: "In a surprising turn of events, the new political party secured a majority in the elections.", approvedBy: []),
        "a4": ArticleModel(id: "a4", title: "Tech Launch", description: "New iPhone unveiled today...", author: "Alice", version: 1, fullContent: "Apple has unveiled its latest iPhone model with new AI features.", approvedBy: []),
        "a5": ArticleModel(id: "a5", title: "Sports Recap", description: "Team A wins championship...", author: "Alice", version: 1, fullContent: "Team A won the championship in a nail-biting final match last night.", approvedBy: []),
        "a6": ArticleModel(id: "a6", title: "Health Alert", description: "Rise in flu cases reported...", author: "Alice", version: 1, fullContent: "Doctors have reported a rise in flu cases in urban areas. Precautions are advised.", approvedBy: []),
        "a7": ArticleModel(id: "a7", title: "Tech Hiring Freeze", description: "Major layoffs in tech...", author: "John", version: 1, fullContent: "Several tech companies announced hiring freezes and layoffs due to market downturns.", approvedBy: []),
        "a8": ArticleModel(id: "a8", title: "Local Fest Begins", description: "City celebrates annual festival...", author: "John", version: 1, fullContent: "The city’s annual cultural fest began today with music, food, and festivities.", approvedBy: []),
        "a9": ArticleModel(id: "a9", title: "Air Pollution Rises", description: "AQI reaches 400 in Delhi...", author: "Robert", version: 1, fullContent: "Delhi recorded its worst air quality index this season, reaching hazardous levels.", approvedBy: []),
        "a10": ArticleModel(id: "a10", title: "Stock Market Dips", description: "Sensex drops 500 points...", author: "Robert", version: 1, fullContent: "Indian stock market dipped due to global uncertainty in trade talks.", approvedBy: []),
        "a11": ArticleModel(id: "a11", title: "Science Expo Opens", description: "Innovations on display...", author: "Alice", version: 1, fullContent: "The annual science expo was inaugurated today, showcasing futuristic tech.", approvedBy: []),
        "a12": ArticleModel(id: "a12", title: "Traffic Alert", description: "Diversions near city center...", author: "John", version: 1, fullContent: "Police have announced new traffic diversions near the central square for repairs.", approvedBy: []),
        "a13": ArticleModel(id: "a13", title: "Fitness Tips", description: "5 exercises to stay fit...", author: "John", version: 1, fullContent: "Experts suggest 30 minutes of daily cardio and strength training to stay healthy.", approvedBy: []),
        "a14": ArticleModel(id: "a14", title: "Cinema Boom", description: "Record-breaking box office...", author: "John", version: 1, fullContent: "Latest film release broke all box office records with highest first-week earnings.", approvedBy: []),
        "a15": ArticleModel(id: "a15", title: "Startup Funding", description: "New unicorn in ed-tech...", author: "Robert", version: 1, fullContent: "An Indian ed-tech startup has raised $100M in Series D funding, becoming a unicorn.", approvedBy: [])
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
           
            for article in articles {
                print(" \(article.id): approvedBy = \(article.approvedBy)")
            }
            completion(true)
        }
    }
}
