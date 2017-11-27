//
//  LabelWithImageViewTableViewCell.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 27/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit

class LabelWithImageViewTableViewCell: UITableViewCell {

    
    @IBOutlet weak var labelTitleCell: UILabel!
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
