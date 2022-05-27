//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Дмитрий Войтович on 01.05.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let weatherService = WeatherService()
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MainViewController(weatherService: weatherService))
        window?.makeKeyAndVisible()
        
        return true
    }
 
}



