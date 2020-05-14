//
//  PlantsTableViewCell.swift
//  BeeGarden
//
//  Created by steven liu on 14/5/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class PlantsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var plantImage: UIImageView!
    
    @IBOutlet weak var plantName: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.cellContentView.layer.cornerRadius = 10
        self.plantImage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
