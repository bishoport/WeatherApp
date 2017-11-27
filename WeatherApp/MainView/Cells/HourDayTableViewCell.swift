//
//  HourDayTableViewCell.swift
//  WeatherApp
//
//  Created by Pedro Ortegon Tesias on 26/11/17.
//  Copyright © 2017 Pedro Ortegon Tesias. All rights reserved.
//

import UIKit

class HourDayTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewIconDay: UIImageView!
    @IBOutlet weak var labelHourDay: UILabel!
    @IBOutlet weak var labelTempDay: UILabel!
    @IBOutlet weak var labelDescDay: UILabel!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
