//
//  ArticleModel.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 10/07/25.
//

import Foundation

struct ArticleModel: Codable, Equatable {
    let id: String
    let title: String
    let description: String
    let author: String
    let version: Int
    let fullContent: String
    var approvedBy: [String]
}
