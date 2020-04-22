//
//  FlowerEntity+CoreDataProperties.swift
//  BeeGarden
//
//  Created by steven liu on 23/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//
//

import Foundation
import CoreData


extension FlowerEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FlowerEntity> {
        return NSFetchRequest<FlowerEntity>(entityName: "FlowerEntity")
    }

    @NSManaged public var desc: String?
    @NSManaged public var image: Data?
    @NSManaged public var name: String?
    @NSManaged public var category: String?
    @NSManaged public var gmonth: String?
    @NSManaged public var gclimate: String?
    @NSManaged public var pollen: String?
    @NSManaged public var nectar: String?
    @NSManaged public var gardens: NSSet?

}

// MARK: Generated accessors for gardens
extension FlowerEntity {

    @objc(addGardensObject:)
    @NSManaged public func addToGardens(_ value: GardenEntity)

    @objc(removeGardensObject:)
    @NSManaged public func removeFromGardens(_ value: GardenEntity)

    @objc(addGardens:)
    @NSManaged public func addToGardens(_ values: NSSet)

    @objc(removeGardens:)
    @NSManaged public func removeFromGardens(_ values: NSSet)

}
