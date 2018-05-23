//
//  Weather.swift
//  WeatherAppAlpha
//
//  Created by Maxim Reshetov on 07.05.2018.
//  Copyright © 2018 Maxim Reshetov. All rights reserved.
//

import Foundation
import UIKit

class CurrentAndForecastWeather {
    
    //Location
    var currentLocation: String?
    var currentLocationIcon = #imageLiteral(resourceName: "currentLocationIcon")
    
    // Current
    var currentTemp_c: Int?
    var currentTemp_f: Int?
    var icon: String?
    var text: String?
    
    
    
    // Hourly Forecast
    var next12Hours: [String]
    var next12HoursTemp: [Int]
    var next12HoursIcons: [String]
    // Astro
    var sunrise: String?
    var sunset: String?
    
    // Daily Forecast
    var dates: [String]
    var datesDescription = ["Сегодня"]
    var dayTemp_c: [Int]
    var nightTemp_c: [Int]
    var dayConditionIcon: [String]
    
    // For Detail View
    var morningTemps: [Int]
    var morningTempsFeelsLike: [Int]
    
    var afternoonTemps: [Int]
    var afternoonTempsFeelsLike: [Int]
    
    var eveningTemps: [Int]
    var eveningTempsFeelsLike: [Int]
    
    var nightTemps: [Int]
    var nightTempsFeelsLike: [Int]
    
    init(dates: [String], next12Hours: [String], next12HoursTemp: [Int], next12HoursIcons: [String], dayTemp_c: [Int], nightTemp_c: [Int], dayConditionIcon: [String], morningTemps: [Int], morningTempsFeelsLike: [Int], afternoonTemps: [Int], afternoonTempsFeelsLike: [Int], eveningTemps: [Int], eveningTempsFeelsLike: [Int], nightTemps: [Int], nightTempsFeelsLike: [Int]) {
        self.dates = dates
        self.next12Hours = next12Hours
        self.next12HoursTemp = next12HoursTemp
        self.next12HoursIcons = next12HoursIcons
        self.dayTemp_c = dayTemp_c
        self.nightTemp_c = nightTemp_c
        self.dayConditionIcon = dayConditionIcon
        self.morningTemps = morningTemps
        self.morningTempsFeelsLike = morningTempsFeelsLike
        self.afternoonTemps = afternoonTemps
        self.afternoonTempsFeelsLike = afternoonTempsFeelsLike
        self.eveningTemps = eveningTemps
        self.eveningTempsFeelsLike = eveningTempsFeelsLike
        self.nightTemps = nightTemps
        self.nightTempsFeelsLike = nightTempsFeelsLike
    }
    
    
    
}










