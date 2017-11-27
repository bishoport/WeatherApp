//
//  GenericWTTableViewCell.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 25/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit

class GenericWTTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelTitle: UILabel!
    
    @IBOutlet weak var imageViewCell: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
