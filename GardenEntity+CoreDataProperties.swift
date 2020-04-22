//
//  GardenEntity+CoreDataProperties.swift
//  BeeGarden
//
//  Created by steven liu on 23/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//
//

import Foundation
import CoreData


extension GardenEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GardenEntity> {
        return NSFetchRequest<GardenEntity>(entityName: "GardenEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var plants: NSSet?

}

// MARK: Generated accessors for plants
extension GardenEntity {

    @objc(addPlantsObject:)
    @NSManaged public func addToPlants(_ value: FlowerEntity)

    @objc(removePlantsObject:)
    @NSManaged public func removeFromPlants(_ value: FlowerEntity)

    @objc(addPlants:)
    @NSManaged public func addToPlants(_ values: NSSet)

    @objc(removePlants:)
    @NSManaged public func removeFromPlants(_ values: NSSet)

}
