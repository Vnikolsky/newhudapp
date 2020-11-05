//
//  CurrentWeather.swift
//  NewHudApp
//
//  Created by Владислав Никольский on 03.11.2020.
//  Copyright © 2020 Владислав Никольский. All rights reserved.
//

import Foundation

struct CurrentWeather {
    let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    
    init?(currentWeatherData: CurrentWeatherData) {
        
        temperature = currentWeatherData.main.temp
        }
}
