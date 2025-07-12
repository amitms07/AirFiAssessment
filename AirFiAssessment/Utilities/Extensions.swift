//
//  Extensions.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 10/07/25.
//

import UIKit
import Foundation

extension UIViewController {
    func showAlert(title: String, message: String, button: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: button, style: .default))
        self.present(alert, animated: true)
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}



extension Notification.Name {
    static let didReconnect = Notification.Name("didReconnect")
}
