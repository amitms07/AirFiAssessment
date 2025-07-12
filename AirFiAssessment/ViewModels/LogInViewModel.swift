//
//  LogInViewModel.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 10/07/25.
//

import Foundation

final class LoginViewModel {

    private let apiService: APIServiceProtocol
    private let coreData = CoreDataManager.shared
    private let defaults = UserDefaults.standard

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func syncArticles(completion: @escaping (Bool) -> Void) {
        apiService.fetchArticleIDs { ids in
            guard !ids.isEmpty else {
                completion(false)
                return
            }
            let group = DispatchGroup()
            for id in ids {
                group.enter()
                self.apiService.fetchArticle(by: id) { article in
                    self.coreData.saveArticle(article)
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                completion(true)
            }
        }
    }

    @discardableResult
    func login(username: String) -> String {
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        let role = trimmedUsername.lowercased() == "robert" ? "Author" : "Reviewer"
        defaults.set(trimmedUsername, forKey: "username")
        defaults.set(role, forKey: "role")
        return role
    }

    func getUserRole() -> String {
        defaults.string(forKey: "role") ?? "Unknown"
    }

    func getUsername() -> String {
        defaults.string(forKey: "username") ?? ""
    }

    func hasLocalArticles() -> Bool {
        return coreData.hasArticles()
    }
}
