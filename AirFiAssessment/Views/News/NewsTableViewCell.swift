//
//  NewsTableViewCell.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 11/07/25.
//
import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkboxButton: UIButton!

    var isChecked: Bool = false {
        didSet {
            let imageName = isChecked ? "checkmark.square" : "square"
            checkboxButton.setImage(UIImage(systemName: imageName), for: .normal)
        }
    }
    var checkboxTapped: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.descriptionLabel.numberOfLines = 0
        checkboxButton.addTarget(self, action: #selector(checkboxClicked), for: .touchUpInside)
    }

    @objc private func checkboxClicked() {
        checkboxTapped?()
    }

    func configure(title: String?, description: String?, isChecked: Bool, showCheckbox: Bool = true, approveCount: Int? = nil) {
        titleLabel.text = title
        if let count = approveCount {
            descriptionLabel.text = "\(description ?? "")\nApprovals: \(count)"
        } else {
            descriptionLabel.text = description
        }
        self.isChecked = isChecked
        checkboxButton.isHidden = !showCheckbox
    }
}
