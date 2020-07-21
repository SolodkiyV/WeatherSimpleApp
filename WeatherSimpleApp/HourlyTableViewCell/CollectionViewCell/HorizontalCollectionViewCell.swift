//
//  HorizontalCollectionViewCell.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 17.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.
//

import UIKit

class HorizontalCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HorizontalCollectionViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "HorizontalCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    func configure(with models: HourlyWeatherEntry) {
        let icon = models.icon.lowercased()
        self.temperatureLabel.text = "\(Int(models.temperature))°"
        self.temperatureLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.timeLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(models.time)))
        self.timeLabel.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.iconImageView.contentMode = .scaleAspectFit
        if icon.contains("clear") {
            if icon.contains("-night") {
                self.iconImageView.image = UIImage(named: "ic_white_night_bright")
            }else {
                self.iconImageView.image = UIImage(named: "ic_white_day_bright")
            }
        }else if icon.contains("cloudy") {
            if icon.contains("-night") {
                self.iconImageView.image = UIImage(named: "ic_white_night_cloudy")
            }else {
                self.iconImageView.image = UIImage(named: "ic_white_day_cloudy")
            }
        }else if icon.contains("rain"){
            if icon.contains("-night") {
                self.iconImageView.image = UIImage(named: "ic_white_night_rain")
            }else {
                self.iconImageView.image = UIImage(named: "ic_white_day_rain")
            }
        }
        self.iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
        self.iconImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    func getDayForDate(_ date: Date?) -> String {
        guard let inputDate = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "RU_ru")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: inputDate)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.3529411765, green: 0.6235294118, blue: 0.9411764706, alpha: 1)
    }
    
}
