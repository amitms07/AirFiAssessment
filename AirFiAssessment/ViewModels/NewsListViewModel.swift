//
//  NewsListViewModel.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 10/07/25.
//


import Foundation
import CoreData

final class NewsListViewModel {

    private let coreData = CoreDataManager.shared
    private let pageSize = 5
    private var currentIndex = 0

    private var allArticles: [ArticleMetadata] = []
    private var grouped: [String: [ArticleMetadata]] = [:]
    private var sectionKeys: [String] = []

    private let role: String
    private let username: String

    var isReviewer: Bool {
        return role.lowercased() == "reviewer"
    }

    init() {
        self.role = UserDefaults.standard.string(forKey: "role") ?? "Reviewer"
        self.username = UserDefaults.standard.string(forKey: "username") ?? "Unknown"
    }

    func loadInitialArticles() {
        currentIndex = 0
        if isReviewer {
            allArticles = coreData.fetchAllArticleMetadata()
        } else {
            allArticles = coreData.fetchArticles(by: username)
        }
        groupArticles()
    }

    func loadMoreArticles() -> Bool {
        let nextIndex = currentIndex + pageSize
        guard nextIndex < allArticles.count else { return false }

        currentIndex = nextIndex
        groupArticles()
        return true
    }

    private func groupArticles() {
        let visibleArticles = Array(allArticles.prefix(currentIndex + pageSize))

        if isReviewer {
            grouped = Dictionary(grouping: visibleArticles, by: { $0.author ?? "Unknown" })
            sectionKeys = grouped.keys.sorted()
        } else {
            grouped = [:]
            sectionKeys = []
        }
    }

    func numberOfSections() -> Int {
        return isReviewer ? sectionKeys.count : 1
    }

    func numberOfRows(in section: Int) -> Int {
        if isReviewer {
            guard let key = sectionKeys[safe: section],
                  let group = grouped[key] else { return 0 }
            return group.count
        } else {
            return Array(allArticles.prefix(currentIndex + pageSize)).count
        }
    }

    func sectionTitle(for section: Int) -> String? {
        return isReviewer ? sectionKeys[safe: section] : nil
    }

    func articleAt(_ indexPath: IndexPath) -> ArticleMetadata {
        if isReviewer,
           let key = sectionKeys[safe: indexPath.section],
           let article = grouped[key]?[safe: indexPath.row] {
            return article
        } else {
            let visible = Array(allArticles.prefix(currentIndex + pageSize))
            return visible[safe: indexPath.row] ?? ArticleMetadata()
        }
    }

    func getDetail(for id: String) -> ArticleDetail? {
        return coreData.fetchArticleDetail(for: id)
    }

    func approveArticles(ids: [String]) {
        for id in ids {
            coreData.appendApproval(for: id, by: username)
        }
    }
}
