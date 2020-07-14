//
//  DaysTableViewCell.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 14.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.
//

import UIKit

class DaysTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "DaysTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DaysTableViewCell", bundle: nil)
    }
    
}
