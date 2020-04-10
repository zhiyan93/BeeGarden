//
//  KnowledgeEntity+CoreDataProperties.swift
//  BeeGarden
//
//  Created by steven liu on 10/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//
//

import Foundation
import CoreData


extension KnowledgeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<KnowledgeEntity> {
        return NSFetchRequest<KnowledgeEntity>(entityName: "KnowledgeEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var image: Data?
    @NSManaged public var time: Date?

}
