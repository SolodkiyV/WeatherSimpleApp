//
//  WeatherDataStruct.swift
//  WeatherSimpleApp
//
//  Created by Valeriy on 15.07.2020.
//  Copyright © 2020 Valerii. All rights reserved.

import Foundation

struct MainStruct: Codable {
    let lon: Double
    let lat: Double
    let timezone: String
    let current: Current
    let hourly: Hourly
    let daily: Daily
}

struct Current: Codable {
    let dt: Int
    let temp: Double
    let humidity: Int
    let wind_speed: Double
    let wind_deg: Int
}

struct Hourly: Codable {
    let dt: Int
    let temp: Double
}

struct Daily: Codable {
    let dt: Int
    let temp: Double
}
