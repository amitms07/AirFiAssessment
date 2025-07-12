//
//  ArticleMetadata+CoreDataProperties.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 10/07/25.
//
//

import Foundation
import CoreData


extension ArticleMetadata {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleMetadata> {
        return NSFetchRequest<ArticleMetadata>(entityName: "ArticleMetadata")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var author: String?
    @NSManaged public var version: Int64

}

extension ArticleMetadata : Identifiable {

}
