//
//  Flower.swift
//  BeeGarden
//
//  Created by steven liu on 4/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import Foundation
import UIKit
class Flower: NSObject {
    var name: String
    var desc: String
    var image : UIImage
    
    init(name: String,desc: String,image: UIImage) {
        self.name = name
        self.desc = desc
        self.image = image
    }
}
