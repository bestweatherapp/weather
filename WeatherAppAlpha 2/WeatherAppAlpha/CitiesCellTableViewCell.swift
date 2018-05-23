//
//  CitiesCellTableViewCell.swift
//  WeatherAppAlpha
//
//  Created by Maxim Reshetov on 11.05.2018.
//  Copyright © 2018 Maxim Reshetov. All rights reserved.
//

import UIKit

class CitiesCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var city: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
