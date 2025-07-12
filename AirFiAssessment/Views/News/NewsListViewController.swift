//
//  NewsListViewController.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 10/07/25.
//

import UIKit
import UIKit

class NewsListViewController: UIViewController {
    
    private let viewModel = NewsListViewModel()
    private var selectedArticles: Set<String> = []
    private var isLoadingMore = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var approveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News"
        
        setupTableView()
        setupLongPressGesture()
        viewModel.loadInitialArticles()
        tableView.estimatedRowHeight = 200
//        tableView.rowHeight = UITableView.automaticDimension

        tableView.reloadData()
        
        if viewModel.isReviewer {
            approveButton.addTarget(self, action: #selector(handleApprove), for: .touchUpInside)
        } else {
            approveButton.isHidden = true
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        
    }
    
    private func setupLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        tableView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleApprove() {
        viewModel.approveArticles(ids: Array(selectedArticles))
        selectedArticles.removeAll()
        tableView.reloadData()
        showAlert(title: "Approved", message: "Selected articles approved.")
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard viewModel.isReviewer else { return }
        
        let point = gesture.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point), gesture.state == .began else { return }
        
        let article = viewModel.articleAt(indexPath)
        guard let id = article.id else { return }
        
        if selectedArticles.contains(id) {
            selectedArticles.remove(id)
        } else {
            selectedArticles.insert(id)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension NewsListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.sectionTitle(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let article = viewModel.articleAt(indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsTableViewCell
        
        if viewModel.isReviewer {
            let isSelected = selectedArticles.contains(article.id ?? "")
            cell.configure(title: article.title,
                           description: article.descriptionText,
                           isChecked: isSelected,
                           showCheckbox: true)
            
            cell.checkboxTapped = { [weak self] in
                guard let self = self, let id = article.id else { return }
                if self.selectedArticles.contains(id) {
                    self.selectedArticles.remove(id)
                } else {
                    self.selectedArticles.insert(id)
                }
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        } else {
           
            let approveCount = (viewModel.getDetail(for: article.id ?? "")?.approvedBy as? [String])?.count ?? 0
            
            cell.configure(title: article.title,
                           description: article.descriptionText,
                           isChecked: false,
                           showCheckbox: false,
                           approveCount: approveCount)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = viewModel.articleAt(indexPath)
        guard let id = article.id else { return }
        
        if viewModel.isReviewer {
            if !selectedArticles.isEmpty {
                // toggle selection
                if selectedArticles.contains(id) {
                    selectedArticles.remove(id)
                } else {
                    selectedArticles.insert(id)
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            } else {
               
                openDetail(for: id)
            }
        } else {
            openDetail(for: id)
        }
    }
    
    private func openDetail(for articleID: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
            detailVC.articleID = articleID
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height - 50, !isLoadingMore {
            isLoadingMore = true
            if viewModel.loadMoreArticles() {
                tableView.reloadData()
            }
            isLoadingMore = false
        }
    }
}
