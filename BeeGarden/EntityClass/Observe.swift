//
//  Observe.swift
//  BeeGarden
//
//  Created by steven liu on 4/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import Foundation
import UIKit
class Observe :NSObject {
    var name: String
    var desc: String
    var longitude: Double
    var latitude: Double
    var weather : String
    var time : Date
    var image : UIImage
    
    init(name: String,desc: String,longitude: Double,latitude: Double, weather: String, time: Date, image: UIImage) {
        self.name = name
        self.desc = desc
        self.longitude = longitude
        self.latitude = latitude
        self.weather = weather
        self.time = time
        self.image = image
    }
}
