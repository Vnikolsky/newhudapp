//
//  CurrentWeatherData.swift
//  NewHudApp
//
//  Created by Владислав Никольский on 03.11.2020.
//  Copyright © 2020 Владислав Никольский. All rights reserved.
//

import Foundation

struct CurrentWeatherData: Codable {
   // let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
        
    enum CodingKeys: String, CodingKey {
        case temp
        
    }
}

struct Weather: Codable {
    let id: Int
}
