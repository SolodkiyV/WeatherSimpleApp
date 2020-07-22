//
//  DaysTableViewCell.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 14.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.
//

import UIKit

class DaysTableViewCell: UITableViewCell {
    
    @IBOutlet var dayLabel: UILabel!
    @IBOutlet var minMaxTempLabel: UILabel!
    @IBOutlet var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let backgroundView = UIView()
        backgroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.selectedBackgroundView = backgroundView
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if self.isSelected == true {

            self.layer.shadowColor = #colorLiteral(red: 0.3529411765, green: 0.6235294118, blue: 0.9411764706, alpha: 1)
            self.dayLabel.textColor = #colorLiteral(red: 0.3529411765, green: 0.6235294118, blue: 0.9411764706, alpha: 1)
            self.minMaxTempLabel.textColor = #colorLiteral(red: 0.3529411765, green: 0.6235294118, blue: 0.9411764706, alpha: 1)
            self.dayLabel.textColor = #colorLiteral(red: 0.3529411765, green: 0.6235294118, blue: 0.9411764706, alpha: 1)
            self.iconImageView.tintColor = #colorLiteral(red: 0.3529411765, green: 0.6235294118, blue: 0.9411764706, alpha: 1)
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 0.25
            self.layer.shadowRadius = 15
        
        }else {

            self.layer.shadowOpacity = 0
            self.dayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.minMaxTempLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.dayLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.iconImageView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            // BLUR
            let blurEffect = UIBlurEffect(style: .extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.backgroundView = blurEffectView
        }
    }
    
    static let identifier = "DaysTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "DaysTableViewCell", bundle: nil)
    }
    
    func configure(with model: DailyWeatherEntry) {
        
        let icon = model.icon.lowercased()
        self.minMaxTempLabel.text = "\(Int(model.temperatureHigh))° / \(Int(model.temperatureLow))°"
        self.dayLabel.text = getDayForDate(Date(timeIntervalSince1970: Double(model.time)))
        
        if icon.contains("clear") {
            
            self.iconImageView.image = UIImage(named: "ic_white_day_bright")
        }else if icon.contains("cloudy") {
            
            self.iconImageView.image = UIImage(named: "ic_white_day_cloudy")
        }else {
            
            self.iconImageView.image = UIImage(named: "ic_white_day_rain")
        }
        
        self.iconImageView.image = iconImageView.image?.withRenderingMode(.alwaysTemplate)
    }
    
    func getDayForDate(_ date: Date?) -> String {
        
        guard let inputDate = date else {
            
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "RU_ru")
        formatter.dateFormat = "E"
        return formatter.string(from: inputDate).uppercased()
    }
}
