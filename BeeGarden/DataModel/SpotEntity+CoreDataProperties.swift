//
//  SpotEntity+CoreDataProperties.swift
//  BeeGarden
//
//  Created by steven liu on 12/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//
//

import Foundation
import CoreData


extension SpotEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SpotEntity> {
        return NSFetchRequest<SpotEntity>(entityName: "SpotEntity")
    }

    @NSManaged public var category: Int16
    @NSManaged public var desc: String?
    @NSManaged public var email: String?
    @NSManaged public var image: Data?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var openhour: String?
    @NSManaged public var place: String?
    @NSManaged public var website: String?

}
