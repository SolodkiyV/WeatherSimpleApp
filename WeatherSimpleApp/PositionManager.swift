//
//  PositionManager.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 17.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.
//

import UIKit
import MapKit

class PositionManager: NSObject {
    
    static let sharedInstance = PositionManager()
    
    var currentPosition = CLLocation.init(latitude: 47.784243, longitude: 35.18404)
    var currentCity = "Запорожье"
}

