//
//  BeeEntity+CoreDataProperties.swift
//  BeeGarden
//
//  Created by steven liu on 4/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//
//

import Foundation
import CoreData


extension BeeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BeeEntity> {
        return NSFetchRequest<BeeEntity>(entityName: "BeeEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var desc: String?
    @NSManaged public var image: String?

}
