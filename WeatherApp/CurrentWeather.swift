//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Дмитрий Войтович on 01.05.2022.
//

import Foundation
import UIKit

struct CurrentWeather: Codable {
    let address: String
    let days: [CurrentWeatherInfo]
}

struct CurrentWeatherInfo: Codable {
    let pressure: Double
    let feelslike: Double
    let humidity: Double
    let temp: Double
    let icon: String
}

extension CurrentWeatherInfo {
  var pressureString: String {
    return "\(Int((pressure*3)/4)) mm"
  }
  
  var humidityString: String {
    return "\(Int(humidity)) %"
  }
  
  var tempString: String {
    return "\(Int(5 / 9 * (temp - 32)))˚C"
  }
  
  var feelslikeString: String {
    return "Feels like: \(Int(5 / 9 * (feelslike - 32)))˚C"
  }
}

