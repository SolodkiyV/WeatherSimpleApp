//
//  HeaderTableViewCell.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 21.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet var dayLabelll: UILabel!
    @IBOutlet var minMaxTempLabelll: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet weak var windSideIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "HeaderTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HeaderTableViewCell", bundle: nil)
    }
}
