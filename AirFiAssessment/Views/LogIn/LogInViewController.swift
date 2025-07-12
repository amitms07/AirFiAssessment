//
//  LogInViewController.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 10/07/25.
//


import UIKit

class LoginViewController: UIViewController {

    private let viewModel = LoginViewModel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        observeNetworkReconnect()
        handleSync()
        setupNetworkMonitor()
    }

    @IBAction func syncArticle(_ sender: Any) {
        handleSync()
    }
    
    private func setupUI() {
      
        view.backgroundColor = .white

        view.addSubview(activityIndicator)
        activityIndicator.center = view.center

        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    }

    private func observeNetworkReconnect() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleReconnect),
                                               name: .didReconnect,
                                               object: nil)
    }

    @objc private func handleReconnect() {
        guard !activityIndicator.isAnimating else { return }
        handleSync()
    }

    @objc private func handleLogin() {
        guard let username = usernameField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !username.isEmpty else {
            showAlert(title: "Error", message: "Please enter a username")
            return
        }

        _ = viewModel.login(username: username)

        guard viewModel.hasLocalArticles() else {
            showAlert(title: "Please sync the app", message: "No articles available in offline mode.")
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newsVC = storyboard.instantiateViewController(withIdentifier: "NewsListViewController") as! NewsListViewController
        navigationController?.pushViewController(newsVC, animated: true)


    }

    private func handleSync() {
        activityIndicator.startAnimating()
        viewModel.syncArticles { [weak self] success in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                let message = success ? "Articles synced successfully!" : "Failed to sync."
                self?.showAlert(title: "Sync", message: message)
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupNetworkMonitor() {
        NetworkMonitor.shared.onConnect = { [weak self] in
            DispatchQueue.main.async {
                self?.showToast(message: "Back online")
                self?.viewModel.syncArticles { success in
                    DispatchQueue.main.async {
                        let message = success ? "Auto-sync completed successfully." : "Auto-sync failed."
                        self?.showToast(message: message)
                    }
                }
            }
        }

        NetworkMonitor.shared.onDisconnect = { [weak self] in
            DispatchQueue.main.async {
                self?.showToast(message: "No internet connection")
            }
        }
    }

    
    private func showToast(message: String, duration: TimeInterval = 2.0) {
        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.font = .systemFont(ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true

        let maxSize = CGSize(width: self.view.bounds.size.width - 40, height: self.view.bounds.size.height)
        var expectedSize = toastLabel.sizeThatFits(maxSize)
        expectedSize.width += 20
        expectedSize.height += 20

        toastLabel.frame = CGRect(
            x: (self.view.frame.size.width - expectedSize.width) / 2,
            y: self.view.frame.size.height - 100,
            width: expectedSize.width,
            height: expectedSize.height
        )

        self.view.addSubview(toastLabel)

        UIView.animate(withDuration: 0.5, delay: duration, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }

}
