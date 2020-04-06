//
//  Planting.swift
//  BeeGarden
//
//  Created by steven liu on 4/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import Foundation
import UIKit
class Planting : NSObject {
    var name: String
    var time: Date
    var counting: Int
    
    init(name:String, time: Date, counting: Int) {
        self.name = name
        self.time = time
        self.counting = counting
    }
}

