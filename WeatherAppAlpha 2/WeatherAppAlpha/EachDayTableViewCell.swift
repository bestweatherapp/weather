//
//  EachDayTableViewCell.swift
//  WeatherAppAlpha
//
//  Created by Maxim Reshetov on 07.05.2018.
//  Copyright © 2018 Maxim Reshetov. All rights reserved.
//

import UIKit

class EachDayTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateDescription: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var dayWeatherIcon: UIImageView!
    @IBOutlet weak var dayTemp_c: UILabel!
    @IBOutlet weak var nightTemp_c: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
