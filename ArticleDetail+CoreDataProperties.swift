//
//  ArticleDetail+CoreDataProperties.swift
//  AirFiAssessment
//
//  Created by Amit Kumar Sahu on 10/07/25.
//
//

import Foundation
import CoreData


extension ArticleDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleDetail> {
        return NSFetchRequest<ArticleDetail>(entityName: "ArticleDetail")
    }

    @NSManaged public var id: String?
    @NSManaged public var fullContent: String?
    @NSManaged public var approvedBy: NSObject?

}

extension ArticleDetail : Identifiable {

}
