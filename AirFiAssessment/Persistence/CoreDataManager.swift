//
//  CoreDataManager.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 10/07/25.
//
import CoreData
import UIKit

final class CoreDataManager {

    static let shared = CoreDataManager()
    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AirFiAssessment")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError(" error loading CoreData: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }


    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    func saveArticle(_ article: ArticleModel) {
        if fetchArticleMetadata(by: article.id) != nil {
            updateArticle(article)
            return
        }

        let metadata = ArticleMetadata(context: context)
        metadata.id = article.id
        metadata.title = article.title
        metadata.descriptionText = article.description
        metadata.author = article.author
        metadata.version = Int64(article.version)

        let detail = ArticleDetail(context: context)
        detail.id = article.id
        detail.fullContent = article.fullContent
        detail.approvedBy = article.approvedBy as NSArray

        saveContext()
    }

    private func updateArticle(_ article: ArticleModel) {
        guard let metadata = fetchArticleMetadata(by: article.id),
              let detail = fetchArticleDetail(for: article.id) else { return }

        metadata.title = article.title
        metadata.descriptionText = article.description
        metadata.author = article.author
        metadata.version = Int64(article.version)

        detail.fullContent = article.fullContent
        detail.approvedBy = article.approvedBy as NSArray

        saveContext()
    }


    func fetchAllArticleMetadata() -> [ArticleMetadata] {
        let request: NSFetchRequest<ArticleMetadata> = ArticleMetadata.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "author", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }


    func fetchPaginatedMetadata(offset: Int, limit: Int) -> [ArticleMetadata] {
        let request: NSFetchRequest<ArticleMetadata> = ArticleMetadata.fetchRequest()
        request.fetchOffset = offset
        request.fetchLimit = limit
        request.sortDescriptors = [NSSortDescriptor(key: "author", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }


    func fetchArticles(by author: String) -> [ArticleMetadata] {
        let request: NSFetchRequest<ArticleMetadata> = ArticleMetadata.fetchRequest()
        request.predicate = NSPredicate(format: "author == %@", author)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }


    func fetchArticleMetadata(by id: String) -> ArticleMetadata? {
        let request: NSFetchRequest<ArticleMetadata> = ArticleMetadata.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return (try? context.fetch(request))?.first
    }


    func fetchArticleDetail(for id: String) -> ArticleDetail? {
        let request: NSFetchRequest<ArticleDetail> = ArticleDetail.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id)
        return (try? context.fetch(request))?.first
    }


    func appendApproval(for id: String, by reviewer: String) {
        guard let detail = fetchArticleDetail(for: id) else { return }
        var approved = (detail.approvedBy as? [String]) ?? []
        if approved.contains(reviewer) == false {
            approved.append(reviewer)
            detail.approvedBy = approved as NSArray
            saveContext()
        }
    }


    func hasArticles() -> Bool {
        let request: NSFetchRequest<ArticleMetadata> = ArticleMetadata.fetchRequest()
        request.fetchLimit = 1
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }


    func clearAllData() {
        [ArticleMetadata.self, ArticleDetail.self].forEach { entity in
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity))
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            try? persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
        }
        saveContext()
    }
}
