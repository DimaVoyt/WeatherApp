//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Дмитрий Войтович on 02.05.2022.
//

import Foundation

class WeatherService {
    var city: String = "Sumy,Ukraine" {
        didSet {
            weatherDidChange?()
        }
    }
    private let day = "/today?key="
    
    var weatherDidChange: (() -> Void)?
    
    func getWeatherInfo(completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        APICaller.shared.getCurrentWeather(city: city, day: day, completion: completion)
    }
}
