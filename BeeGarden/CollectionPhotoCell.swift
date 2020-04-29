//
//  CollectionPhotoCell.swift
//  BeeGarden
//
//  Created by steven liu on 29/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class CollectionPhotoCell: UICollectionViewCell {
    @IBOutlet weak var checkmarkLabel: UILabel!
     @IBOutlet weak var imageView: UIImageView!
     
    @IBOutlet weak var nameLabel: UILabel!
    var isInEditingMode: Bool = false {
        didSet {
            checkmarkLabel.isHidden = !isInEditingMode
        }
    }

    // 2
    override var isSelected: Bool {
        didSet {
            if isInEditingMode {
                checkmarkLabel.text = isSelected ? "✓" : ""
            }
         
         if self.isSelected {
             self.layer.borderWidth = 5
             self.layer.borderColor = UIColor.red.cgColor
         }
         else {
             self.layer.borderWidth = 0
         }
           
        }
    }
}
