//
//  ObserveEntity+CoreDataProperties.swift
//  BeeGarden
//
//  Created by steven liu on 6/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//
//

import Foundation
import CoreData


extension ObserveEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ObserveEntity> {
        return NSFetchRequest<ObserveEntity>(entityName: "ObserveEntity")
    }

    @NSManaged public var desc: String?
    @NSManaged public var image: Data?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var time: Date?
    @NSManaged public var weather: String?

}
