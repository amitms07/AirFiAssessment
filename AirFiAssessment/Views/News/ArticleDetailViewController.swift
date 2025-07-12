//
//  ArticleDetailViewController.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 11/07/25.
//

import UIKit

class ArticleDetailViewController: UIViewController {


    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var approvedByLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!

    var articleID: String?
    private let coreData = CoreDataManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Article Detail"
        loadArticle()
    }

    private func loadArticle() {
        guard let id = articleID,
              let metadata = coreData.fetchArticleMetadata(by: id),
              let detail = coreData.fetchArticleDetail(for: id) else {
            showAlert(title: "Error", message: "Article not found.")
            return
        }

        titleLabel.text = metadata.title ?? "No Title"
        authorLabel.text = "Author: \(metadata.author ?? "Unknown")"
        versionLabel.text = "Version: \(metadata.version)"
        
        let approvedBy = (detail.approvedBy as? [String]) ?? []
        approvedByLabel.text = approvedBy.isEmpty ? "Approved By: None" : "Approved By: \(approvedBy.joined(separator: ", "))"

        contentTextView.text = detail.fullContent ?? "No content available."
    }


    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
