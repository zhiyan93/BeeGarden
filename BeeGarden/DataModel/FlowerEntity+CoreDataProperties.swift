//
//  FlowerEntity+CoreDataProperties.swift
//  BeeGarden
//
//  Created by steven liu on 6/4/20.
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

}
