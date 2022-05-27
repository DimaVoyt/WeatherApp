//
//  APICaller.swift
//  WeatherApp
//
//  Created by Дмитрий Войтович on 01.05.2022.
//

import Foundation
import UIKit


enum Constants {
    static let baseURL = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/"
    static let API_KEY = "NDX96Z8PSNFFYRA5VKX7GSQ58"
    static let include = "&include=obs%2Cfcst%2Cstats%2Calerts%2Ccurrent%2Chistfcst&elements=feelslike,temp,icon,pressure,humidity"
    
}

final class APICaller {
    static let shared = APICaller()
    
    
    func getCurrentWeather(city: String,
                           day: String,
                           completion: @escaping (Result<CurrentWeather, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.baseURL)\(city)\(day)\(Constants.API_KEY)\(Constants.include)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let result = try JSONDecoder().decode(CurrentWeather.self, from: data)
                DispatchQueue.main.async {
                    completion( .success(result))
                }
            } catch {
                DispatchQueue.main.async {
                    completion( .failure(error))
                }
            }
            
            
        }
        task.resume()
    }
    
    
}
