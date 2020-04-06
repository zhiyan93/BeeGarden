//
//  PlantRecordEntity+CoreDataProperties.swift
//  BeeGarden
//
//  Created by steven liu on 6/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//
//

import Foundation
import CoreData


extension PlantRecordEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlantRecordEntity> {
        return NSFetchRequest<PlantRecordEntity>(entityName: "PlantRecordEntity")
    }

    @NSManaged public var counting: Int16
    @NSManaged public var name: String?
    @NSManaged public var time: Date?

}
