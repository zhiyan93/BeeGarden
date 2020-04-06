//
//  GalleryTableViewCell.swift
//  BeeGarden
//
//  Created by steven liu on 5/4/20.
//  Copyright © 2020 steven liu. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var observeImage : UIImageView!
    @IBOutlet weak var observeName : UILabel!
    @IBOutlet weak var observeTime : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        observeName.adjustsFontForContentSizeCategory = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
